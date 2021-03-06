/*

Copyright (c) 2013, Project OSRM, Dennis Luxen, others
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list
of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#include "../typedefs.h"
#include "../Algorithms/StronglyConnectedComponents.h"
#include "../DataStructures/DynamicGraph.h"
#include "../DataStructures/QueryEdge.h"
#include "../DataStructures/TurnInstructions.h"
#include "../Util/GraphLoader.h"
#include "../Util/OSRMException.h"
#include "../Util/SimpleLogger.h"
#include "../Util/FingerPrint.h"

#include <fstream>
#include <memory>
#include <string>
#include <vector>

typedef QueryEdge::EdgeData EdgeData;
typedef DynamicGraph<EdgeData>::InputEdge InputEdge;

std::vector<NodeInfo> internal_to_external_node_map;
std::vector<TurnRestriction> restrictions_vector;
std::vector<NodeID> bollard_node_IDs_vector;
std::vector<NodeID> traffic_light_node_IDs_vector;

int main(int argc, char *argv[])
{
    LogPolicy::GetInstance().Unmute();
    if (argc < 3)
    {
        SimpleLogger().Write(logWARNING) << "usage:\n" << argv[0] << " <osrm> <osrm.restrictions>";
        return -1;
    }

    try
    {
        SimpleLogger().Write() << "Using restrictions from file: " << argv[2];
        std::ifstream restriction_ifstream(argv[2], std::ios::binary);
        const FingerPrint fingerprint_orig;
        FingerPrint fingerprint_loaded;
        restriction_ifstream.read((char *)&fingerprint_loaded, sizeof(FingerPrint));

        if (!fingerprint_loaded.TestGraphUtil(fingerprint_orig))
        {
            SimpleLogger().Write(logWARNING) << argv[2] << " was prepared with a different build. "
                                                           "Reprocess to get rid of this warning.";
        }

        if (!restriction_ifstream.good())
        {
            throw OSRMException("Could not access <osrm-restrictions> files");
        }
        uint32_t usable_restriction_count = 0;
        restriction_ifstream.read((char *)&usable_restriction_count, sizeof(uint32_t));
        restrictions_vector.resize(usable_restriction_count);

        if (usable_restriction_count>0)
        {
            restriction_ifstream.read((char *)&(restrictions_vector[0]),
                                 usable_restriction_count * sizeof(TurnRestriction));
        }
        restriction_ifstream.close();

        std::ifstream input_stream;
        input_stream.open(argv[1], std::ifstream::in | std::ifstream::binary);

        if (!input_stream.is_open())
        {
            throw OSRMException("Cannot open osrm file");
        }

        std::vector<ImportEdge> edge_list;
        const NodeID number_of_nodes = readBinaryOSRMGraphFromStream(input_stream,
                                                                     edge_list,
                                                                     bollard_node_IDs_vector,
                                                                     traffic_light_node_IDs_vector,
                                                                     &internal_to_external_node_map,
                                                                     restrictions_vector);
        input_stream.close();

        BOOST_ASSERT_MSG(restrictions_vector.size() == usable_restriction_count,
                         "size of restrictions_vector changed");

        SimpleLogger().Write() << restrictions_vector.size() << " restrictions, "
                               << bollard_node_IDs_vector.size() << " bollard nodes, "
                               << traffic_light_node_IDs_vector.size() << " traffic lights";

        /***
         * Building an edge-expanded graph from node-based input an turn
         * restrictions
         */

        SimpleLogger().Write() << "Starting SCC graph traversal";
        std::shared_ptr<TarjanSCC> tarjan =
            std::make_shared<TarjanSCC>(number_of_nodes,
                                        edge_list,
                                        bollard_node_IDs_vector,
                                        traffic_light_node_IDs_vector,
                                        restrictions_vector,
                                        internal_to_external_node_map);
        std::vector<ImportEdge>().swap(edge_list);

        tarjan->Run();
        SimpleLogger().Write() << "finished component analysis";
    }
    catch (const std::exception &e)
    {
        SimpleLogger().Write(logWARNING) << "[exception] " << e.what();
    }
    return 0;
}
