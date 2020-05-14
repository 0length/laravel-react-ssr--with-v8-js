import React from 'react'
import Home from "./Home"
import About from "./About"

interface Pages {
    [index: string]: JSX.Element
}

const Pages: any = {
    home: <Home />,
    about: <About />
}

export default Pages