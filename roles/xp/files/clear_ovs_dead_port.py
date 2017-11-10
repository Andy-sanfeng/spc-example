#!/usr/bin/python
# -*- coding: utf-8 -*-


import commands

bridge = 'br0'

def get_ports(bridge):
    cmd = 'ovs-vsctl list-ports %s | grep -v "eth"' % (bridge)
    status, ports = commands.getstatusoutput(cmd)
    if status != 0 and not ports:
        return
    return ports.split('\n')   

def get_interface(port):
   cmd = 'ovs-vsctl --bare -- --columns=interface list port %s' % (port)
   # cmd = 'ovs-vsctl --bare -- --columns=interface list port eth2'
    status, interface = commands.getstatusoutput(cmd)
    if status != 0:
        return
    return interface


def get_ofport(interface):
    cmd = 'ovs-vsctl --bare -- --columns=ofport list interface %s' % (interface)
    status, ofport = commands.getstatusoutput(cmd)
    if status != 0:
        print("Error:  get interface %s ofport error." % (bridge)) 
    return ofport

def clear_port(bridge, port):
    cmd = 'ovs-vsctl del-port %s %s' % (bridge, port)
    interface = get_interface(port)
    if not interface:
        return
    ofport = get_ofport(interface)
    if ofport == '-1':
#        print("----port=%s-----interface=%s------ofport=%s---" % (port, interface, ofport))
        status, output = commands.getstatusoutput(cmd)
        if status == 0:
            print("Cler port %s sucess." %(port))
        else:
            print("Cler port %s failes" %(port))
        
if __name__ == '__main__':
    ports= get_ports('br0')
    if ports:
        for port in ports:
            clear_port('br0', port)
