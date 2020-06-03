import React from 'react'
import { createGlobalStyle } from 'styled-components'
import Pages from '../Pages'

const Footer: React.FC<any> = ({setPage, mainTitle})=>{
    const allPages = Object.keys(Pages)
    const handleLink = (e: any) =>{
        const page = e.target.dataset.id
        window.history.pushState(page.toUpperCase(), `${page.toUpperCase()}`, `/${page}`);
        document.title = `${mainTitle} | ${page[0].toUpperCase() + page.slice(1)}`
        setPage(page)
    }

    return(<>
        <LocalStyle />
        <div className={'footer__warapper'}>
            <div className={'footer__container'}>
                <div className={'footer-logo__wrapper'}>
                    <div className={'footer-logo__container'}>LOGO</div>
                </div>
                <div className={'footer-menu__wrapper'}>
                    <div className={'footer-menu__container'}>
                        {
                            allPages.map((menu)=>(
                                <div className={'footer-menu-item__wrapper'}>
                                    <div className={'footer-menu-item__Continer'} data-id={menu} onClick={(e)=>handleLink(e)}>{menu}</div>
                                </div>
                            ))
                        }
                    </div>
                </div>
                <div className={'footer-logo__wrapper'}>
                    <div className={'footer-logo__container'}>Related Post</div>
                </div>
            </div>
        </div>
    </>)
}

const LocalStyle = createGlobalStyle`
    .footer__warapper {
    }
    .footer__container {
        
    }

    .footer-menu__wrapper {
        
    }

    .footer-menu__container {
        
    }

    .footer-menu-item__wrapper {
        text-transform: capitalize;
    }

    .footer-menu-item__container {
        
    }
`
export default Footer