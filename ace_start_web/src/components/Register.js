import styled from 'styled-components'
import {Link} from 'react-router-dom'

const RegisterForm = styled.div`
    width: 100%;
    height: 100vh;
    background: #642B73;  /* fallback for old browsers */
    // background: -webkit-linear-gradient(45deg, rgba(255,255,255,1),rgba(0,0,0,0.1),rgba(255,255,255,1));  /* Chrome 10-25, Safari 5.1-6 */
    // background: linear-gradient(45deg, rgba(255,255,255,1),rgba(0,0,0,0.1),rgba(255,255,255,1)); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
    background: black;
    display: flex;
    justify-content: space-evenly;
    text-align: center;
    align-items: center;
    .card {
        width: 40%;
        height: 55vh;
        padding: 5vh 0;
        border-radius: 4vw;
        background: #642B73;  /* fallback for old browsers */
        background: -webkit-linear-gradient(to bottom, #C6426E, #642B73);  /* Chrome 10-25, Safari 5.1-6 */
        background: linear-gradient(to bottom, #C6426E, #642B73); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
        box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
        display: flex;
        align-items: center;
        justify-content: center;
        div {
            width: 100%;
            height: 40vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            input {
                padding: 1vw 0;
                margin: 0.5vw auto;
                width: 40%;
                border: none;
                border-top-right-radius: 2vw;
                background: rgba(255,255,255,0.9);
                color: black;
                &::placeholder {
                    padding: 0 1vw;
                    color: black;
                }
            }
            input:-webkit-autofill,
            input:-webkit-autofill:hover,
            input:-webkit-autofill:focus,
            input:-webkit-autofill:active {
                transition: background-color 5000s ease-in-out 0s;
            }
            button {
                padding: 1vw;
                margin: 0.5vw auto;
                width: 40%;
                border: none;
                border-top-right-radius: 2vw;
                background: rgba(0,0,0,0.7);
                color: white;
                cursor: pointer;
            }
            p {
                width: 60%;
                color: white;
                font-size: 1vw;
                a {
                    color: black;
                    font-weight: 600;
                    letter-spacing: 0.1vw;
                }
            }
        }
    }
`

const Register = () => {
    return (
        <RegisterForm>
                <form className="card">
                    <div>
                        <input type="text" name="username" placeholder="Username" />
                        <input type="text" name="email" placeholder="Email" />
                        <input type="number" name="mobile" placeholder="Mobile" />
                        <input type="password" name="password" placeholder="Password" />
                        <button>Sign Up</button>
                        <p>Already have an account?<br/><Link to="/login">Sign In Here!</Link></p>
                    </div>
                </form>
        </RegisterForm>
    )
}

export default Register