#ifndef OSMIUM_DETAIL_MMAP_VECTOR_ANON_HPP
#define OSMIUM_DETAIL_MMAP_VECTOR_ANON_HPP

/*

This file is part of Osmium (http://osmcode.org/libosmium).

Copyright 2013 Jochen Topf <jochen@topf.org> and others (see README).

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/

#ifdef __linux__

#include <cstddef>

#include <osmium/index/detail/typed_mmap.hpp>
#include <osmium/index/detail/mmap_vector_base.hpp>

namespace osmium {

    namespace detail {

        /**
        * This class looks and behaves like STL vector, but uses mmap internally.
        */
        template <typename T>
        class mmap_vector_anon : public mmap_vector_base<T, mmap_vector_anon> {

        public:

            mmap_vector_anon() :
                mmap_vector_base<T, osmium::detail::mmap_vector_anon>(
                    -1,
                    osmium::detail::mmap_vector_size_increment,
                    0,
                    osmium::detail::typed_mmap<T>::map(osmium::detail::mmap_vector_size_increment)) {
            }

            void reserve(size_t new_capacity) {
                if (new_capacity > this->capacity()) {
                    this->data(osmium::detail::typed_mmap<T>::remap(this->data(), this->capacity(), new_capacity));
                    this->m_capacity = new_capacity;
                }
            }

        }; // class mmap_vector_anon

    } // namespace detail

} // namespace osmium

#endif // __linux__

#endif // OSMIUM_DETAIL_MMAP_VECTOR_ANON_HPP
