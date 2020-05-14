import React, { useState } from 'react'
import Pages from './Pages'
import Navbar from './Layout/Navbar'

const App: React.FC<any> = ({path, title}) =>{
    const [page, setPage] = useState(path)
    const AvaliablePage = ()=>(Pages[page])
    if(!AvaliablePage()){
        return <h1>404 no life</h1>
    }
    return (<div>
        <Navbar {...{setPage, mainTitle: title}}/>
        {
            <AvaliablePage />
        }
    </div>)
}

export default App