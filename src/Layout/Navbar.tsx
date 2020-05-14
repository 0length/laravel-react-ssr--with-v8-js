import React from 'react'

const Navbar: React.FC<any> = ({setPage, mainTitle})=>{
    const handleLink = (e: any) =>{
        const page = e.target.dataset.id
        window.history.pushState(page.toUpperCase(), `${page.toUpperCase()}`, `/${page}`);
        document.title = `${mainTitle} | ${page[0].toUpperCase() + page.slice(1)}`
        setPage(page)
    }
    return(<>
        <ul>
            <li data-id="home" onClick={(e)=>handleLink(e)}>Home</li>
            <li data-id="about" onClick={(e)=>handleLink(e)}>About</li>
        </ul>
    </>)
}

export default Navbar