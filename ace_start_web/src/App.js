import {Route, BrowserRouter as Router} from 'react-router-dom'
import Main from './components/Main'
import Login from './components/Login'
import Register from './components/Register'

function App() {
  return (
    <div className="App">
      <Router>
        <Route exact path="/" component={Main} />
        <Route exact path="/login" component={Login} />
        <Route exact path="/register" component={Register} />
      </Router>
    </div>
  );
}

export default App;
