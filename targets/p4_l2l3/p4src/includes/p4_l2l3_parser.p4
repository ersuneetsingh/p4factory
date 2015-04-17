/*
Copyright 2013-present Barefoot Networks, Inc. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
// Template parser.p4 file for p4_l2l3
// Edit this file as needed for your P4 program
// This exmaple shows basic L2 and L3 (ipv4) parsing

header ethernet_t ethernet;

parser start {
    return parse_ethernet;
}

#define ETHERTYPE_VLAN 0x8100
#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_ARP 0x0806

parser parse_ethernet {
    extract(ethernet);
    return select(latest.etherType) {
        ETHERTYPE_VLAN : parse_vlan;
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

header vlan_tag_t vlan_tag_;

parser parse_vlan {
    extract(vlan_tag_);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

header ipv4_t ipv4;

parser parse_ipv4 {
    extract(ipv4);
    return ingress;
}
