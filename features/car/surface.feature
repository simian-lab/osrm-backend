@routing @car @surface
Feature: Car - Surfaces

    Background:
        Given the profile "car"

    Scenario: Car - Routeability of tracktype tags
        Then routability should be
            | tracktype | bothw |
            | grade1    | x     |
            | grade2    | x     |
            | grade3    | x     |
            | grade4    | x     |
            | grade5    | x     |
            | nonsense  | x     |

    Scenario: Car - Routability of smoothness tags
        Then routability should be
            | smoothness    | bothw |
            | excellent     | x     |
            | good          | x     |
            | intermediate  | x     |
            | bad           | x     |
            | very_bad      | x     |
            | horrible      | x     |
            | very_horrible | x     |
            | impassable    |       |
            | nonsense      | x     |

    Scenario: Car - Routabiliy of surface tags
        Then routability should be
            | surface  | bothw |
            | asphalt  | x     |
            | sett     | x     |
            | gravel   | x     |
            | nonsense | x     |


    Scenario: Car - Good surfaces should not grant access
        Then routability should be
            | access       | tracktype | smoothness | surface | bothw |
            |              |           |            |         | x     |
            | no           | grade1    | excellent  | asphalt |       |
            | private      | grade1    | excellent  | asphalt |       |
            | agricultural | grade1    | excellent  | asphalt |       |
            | forestry     | grade1    | excellent  | asphalt |       |
            | emergency    | grade1    | excellent  | asphalt |       |

        Scenario: Car - Impassable surfaces should deny access
        These cases are somewhat comflicting, like
        Then routability should be
            | smoothness | bothw |
            |            | x     |
            | impassable |       |

    Scenario: Car - Surfaces should not affect oneway direction
        Then routability should be
            | oneway | tracktype | smoothness | surface  | forw | backw |
            |        | grade1    | excellent  | asphalt  | x    | x     |
            |        | grade5    | very_bad   | mud      | x    | x     |
            |        | nonsense  | nonsense   | nonsense | x    | x     |
            | no     | grade1    | excellent  | asphalt  | x    | x     |
            | no     | grade5    | very_bad   | mud      | x    | x     |
            | no     | nonsense  | nonsense   | nonsense | x    | x     |
            | yes    | grade1    | excellent  | asphalt  | x    |       |
            | yes    | grade5    | very_bad   | mud      | x    |       |
            | yes    | nonsense  | nonsense   | nonsense | x    |       |
            | -1     | grade1    | excellent  | asphalt  |      | x     |
            | -1     | grade5    | very_bad   | mud      |      | x     |
            | -1     | nonsense  | nonsense   | nonsense |      | x     |

    Scenario: Car - Tracktype tags should reduce speed
        Then routability should be
            | highway     | tracktype | forw        |
            | motorway    |           | 72 km/h +-1 |
            | motorway    | grade1    | 32 km/h +-1 |
            | motorway    | grade2    | 27 km/h +-1 |
            | motorway    | grade3    | 24 km/h +-1 |
            | motorway    | grade4    | 20 km/h +-1 |
            | motorway    | grade5    | 16 km/h +-1 |
            | tertiary    |           | 32 km/h +-1 |
            | tertiary    | grade1    | 32 km/h +-1 |
            | tertiary    | grade2    | 27 km/h +-1 |
            | tertiary    | grade3    | 24 km/h +-1 |
            | tertiary    | grade4    | 20 km/h +-1 |
            | tertiary    | grade5    | 16 km/h +-1 |
            | residential |           | 20 km/h +-1 |
            | residential | grade1    | 20 km/h +-1 |
            | residential | grade2    | 20 km/h +-1 |
            | residential | grade3    | 20 km/h +-1 |
            | residential | grade4    | 20 km/h +-1 |
            | residential | grade5    | 16 km/h +-1 |

    Scenario: Car - Surface tags should reduce speed
        Then routability should be
            | highway     | surface         | forw        |
            | motorway    | asphalt         | 72 km/h +-1 |
            | motorway    | concrete        | 72 km/h +-1 |
            | motorway    | concrete:plates | 72 km/h +-1 |
            | motorway    | concrete:lanes  | 72 km/h +-1 |
            | motorway    | paved           | 72 km/h +-1 |
            | motorway    | metal           | 72 km/h +-1 |
            | motorway    | bricks          | 72 km/h +-1 |
            | motorway    | cement          | 72 km/h +-1 |
            | motorway    | compacted       | 65 km/h +-1 |
            | motorway    | paving_stones   | 65 km/h +-1 |
            | motorway    | fine_gravel     | 65 km/h +-1 |
            | motorway    | grass           | 32 km/h +-1 |
            | motorway    | wood            | 32 km/h +-1 |
            | motorway    | sett            | 32 km/h +-1 |
            | motorway    | grass_paver     | 32 km/h +-1 |
            | motorway    | gravel          | 32 km/h +-1 |
            | motorway    | unpaved         | 32 km/h +-1 |
            | motorway    | ground          | 32 km/h +-1 |
            | motorway    | dirt            | 32 km/h +-1 |
            | motorway    | pebblestone     | 32 km/h +-1 |
            | motorway    | tartan          | 32 km/h +-1 |
            | motorway    | cobblestone     | 24 km/h +-1 |
            | motorway    | clay            | 24 km/h +-1 |
            | motorway    | earth           | 24 km/h +-1 |
            | motorway    | stone           | 16 km/h +-1 |
            | motorway    | rocky           | 16 km/h +-1 |
            | motorway    | sand            | 16 km/h +-1 |
            | motorway    | mud             | 8 km/h  +-1 |
            | residential | asphalt         | 20 km/h +-1 |
            | residential | concrete        | 20 km/h +-1 |
            | residential | concrete:plates | 20 km/h +-1 |
            | residential | concrete:lanes  | 20 km/h +-1 |
            | residential | paved           | 20 km/h +-1 |
            | residential | metal           | 20 km/h +-1 |
            | residential | bricks          | 20 km/h +-1 |
            | residential | cement          | 20 km/h +-1 |
            | residential | compacted       | 20 km/h +-1 |
            | residential | paving_stones   | 20 km/h +-1 |
            | residential | fine_gravel     | 20 km/h +-1 |
            | residential | grass           | 20 km/h +-1 |
            | residential | wood            | 20 km/h +-1 |
            | residential | sett            | 20 km/h +-1 |
            | residential | grass_paver     | 20 km/h +-1 |
            | residential | gravel          | 20 km/h +-1 |
            | residential | unpaved         | 20 km/h +-1 |
            | residential | ground          | 20 km/h +-1 |
            | residential | dirt            | 20 km/h +-1 |
            | residential | pebblestone     | 20 km/h +-1 |
            | residential | tartan          | 20 km/h +-1 |
            | residential | cobblestone     | 20 km/h +-1 |
            | residential | clay            | 20 km/h +-1 |
            | residential | earth           | 20 km/h +-1 |
            | residential | stone           | 16 km/h +-1 |
            | residential | rocky           | 16 km/h +-1 |
            | residential | sand            | 16 km/h +-1 |
            | residential | mud             | 8 km/h  +-1 |

    Scenario: Car - Smoothness tags should reduce speed
        Then routability should be
            | highway  | smoothness    | forw        |
            | motorway | excellent     | 72 km/h +-1 |
            | motorway | goood         | 72 km/h +-1 |
            | motorway | intermediate  | 65 km/h +-1 |
            | motorway | bad           | 32 km/h +-1 |
            | motorway | very_bad      | 16 km/h +-1 |
            | motorway | horrible      | 8 km/h  +-1 |
            | motorway | very_horrible | 4 km/h  +-1 |
            | motorway | impassable    |             |

    Scenario: Car - Combination of surface tags should use lowest speed
        Then routability should be
            | highway  | tracktype | surface | smoothness | forw    |
            | motorway |           |         |            | 72 km/h |
            | service  | grade1    | asphalt | excellent  | 12 km/h |
            | motorway | grade5    | asphalt | excellent  | 16 km/h |
            | motorway | grade1    | mud     | excellent  | 8 km/h  |
            | motorway | grade1    | asphalt | horrible   | 8 km/h  |
