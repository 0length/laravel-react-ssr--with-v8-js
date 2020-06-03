import React from 'react'
import { createGlobalStyle } from 'styled-components'
import Pages from '../Pages'

const Navbar: React.FC<any> = ({setPage, mainTitle})=>{
    const allPages = Object.keys(Pages)
    const handleLink = (e: any) =>{
        const page = e.target.dataset.id
        window.history.pushState(page.toUpperCase(), `${page.toUpperCase()}`, `/${page}`);
        document.title = `${mainTitle} | ${page[0].toUpperCase() + page.slice(1)}`
        setPage(page)
    }

    return(<>
        <LocalStyle />
        <div className={'navbar__warapper'}>
            <div className={'navbar__container'}>
                <div className={'navbar-logo__wrapper'}>
                    <div className={'navbar-logo__container'}>LOGO</div>
                </div>
                <div className={'navbar-menu__wrapper'}>
                    <div className={'navbar-menu__container'}>
                        {
                            allPages.map((menu)=>(
                                <div className={'navbar-menu-item__wrapper'}>
                                    <div className={'navbar-menu-item__Continer'} data-id={menu} onClick={(e)=>handleLink(e)}>{menu}</div>
                                </div>
                            ))
                        }
                    </div>
                </div>
            </div>
        </div>
    </>)
}

const LocalStyle = createGlobalStyle`
    .navbar__warapper {
        position: fixed;
        left: 0;
        right: 0;
        top: 0;
        z-index: var(--zIdx-navbar);
        border: 1px solid #000;
        padding: 10px 16px;
    }

    .navbar__container {
        display: flex;
        justify-content: space-between;
    }

    .navbar-logo__wrapper {
        
    }

    .navbar-logo__container {
        
    }

    .navbar-menu__wrapper {
    }

    .navbar-menu__container {
        display: flex;
        
    }

    .navbar-menu-item__wrapper {
        text-transform: capitalize;
    }

    .navbar-menu-item__container {
        color: #fff;
    }
`
export default Navbar