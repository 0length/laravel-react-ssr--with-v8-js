'use strict'
import React from 'react'
import ReactDom from 'react-dom'
import ReactDomServer from 'react-dom/server'
import HomePage from './HomePage'

const globalAny:any = global;
globalAny.React = React;
globalAny.ReactDom = ReactDom;
globalAny.ReactDomServer = ReactDomServer;
globalAny.HomePage = HomePage;
if(!global){
    global = {} as any
}
global = { ...global, ...globalAny}