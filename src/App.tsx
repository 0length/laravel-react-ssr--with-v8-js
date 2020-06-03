import React, { useState } from 'react'
import Pages from './Pages'
import Navbar from './Layout/Navbar'
import { createGlobalStyle } from 'styled-components'
import Footer from './Layout/Footer'

const App: React.FC<any> = ({path, title}) =>{
    const [page, setPage] = useState(path)
    const AvaliablePage = ()=>(Pages[page])
    if(!AvaliablePage()){
        return <h1>404 no life</h1>
    }
    return (<div>
        <GolobalStyle />
        <Navbar {...{setPage, mainTitle: title}}/>
        <div className={'body__wrapper'}>
            <div className={'body__container'}>
            {
                <AvaliablePage />
            }
            </div>
        </div>
        <Footer {...{setPage, mainTitle: title}}/>
    </div>)
}

const GolobalStyle = createGlobalStyle`
:root {
    --zIdx-navbar: 90;
}

html {
    box-sizing: border-box;
  }

*,
*:before,
*:after {
box-sizing: inherit;
}

@mixin clearfix {
    &:after {
      display: table;
      clear: both;
      content: '';
    }
}

.layout__wrapper {
    max-width: 1140px;
    margin-right: auto;
    margin-left: auto;
}

.three-col-grid .grid-item {
    width: 380px;
    float: left;
}

.three-col-grid { @include clearfix; }

.grid-item {
    width: calc((100% - 20px * 2) / 3);
}

.grid-item:last-child, .grid-item:nth-child(3n+3) {
    margin-right: 0;
    float: right;
}


.body__wrapper{
    // position: relative;
    min-height: 80vh;
    max-width: 100vw;
    top: 35px;
}

.body__container{
    height: 100%;
}
`
export default App