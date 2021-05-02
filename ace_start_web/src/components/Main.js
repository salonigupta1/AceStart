import styled from 'styled-components'
import {Link} from 'react-router-dom'
import web_graphic from '../images/web_graphic.png'

const Elem = styled.div`
    width: 100%;
    height: 100vh;
    position: absolute;
    background: #642B73;  /* fallback for old browsers */
    background: -webkit-linear-gradient(to bottom, #C6426E, #642B73);  /* Chrome 10-25, Safari 5.1-6 */
    background: linear-gradient(to bottom, #C6426E, #642B73); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
    display: flex;
    justify-content: center;
    align-items: center;
    .image {
        width: 40%;
        margin: 0;
        text-align: center;
        img {
            max-width: 40vw;
            max-height: 40vw;
            margin: 0 auto;
        }
    }
    .buttons {
        width: 40%;
        margin: 0;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        button {
            margin: 1vw auto;
            color: white;
            border: 2px solid white;
            width: 50%;
            border-radius: 3vw;
            background: black;
            padding: 0.5vw 0;
            a {
                text-decoration: none;
                color: white;
                font-size: 1.2vw;
                letter-spacing: 0.2vw;
            }
        }
        .headings {
            margin: 2vw auto;
            padding: 0 0 2vw 0;
            h1,h4 {
                width: 100%;
                line-height: 100%;
                margin: 0;
                color: white;
                font-size: 5vw;
            }
            h4 {
                font-weight: 400;
                font-size: 2.5vw;
            }
        }
    }
`

const Main = () => {
    return (
        <Elem>
            <div className="image">
                <img src={web_graphic} />
            </div>
            <div className="buttons">
                <div className="headings">
                    <h1>AceStart</h1>
                    <h4>Dream and Acheive</h4>
                </div>
                <button><Link to="/login">Login</Link></button>
                <button><Link to="/register">Register Now</Link></button>
            </div>
        </Elem>
    )
}

export default Main