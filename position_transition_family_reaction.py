#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 13 00:06:53 2018

@author: ruddirodriguez
"""
"""    
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
"""
def position_transition_family_reaction (L,globalrate,r1):
        
    mnumber = 0
    sumalpha = L[1]/globalrate
    while (r1) >= (sumalpha):
        mnumber = mnumber + 1
        sumalpha = sumalpha + (L[mnumber]/globalrate)
    return (mnumber) 
    
