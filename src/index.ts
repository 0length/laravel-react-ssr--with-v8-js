'use strict'
import React from 'react'
import ReactDom from 'react-dom'
import ReactDomServer from 'react-dom/server'
import App from './App'

const globalAny:any = global;
globalAny.React = React;
globalAny.ReactDom = ReactDom;
globalAny.ReactDomServer = ReactDomServer;
globalAny.App = App;
if(!global){
    global = {} as any
}
global = { ...global, ...globalAny}