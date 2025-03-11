import logo from './logo.svg';
import './App.css';
import ThemeToggle from './components/ThemeToggle';
import { BrowserRouter as Router, Route, Routes, Switch, Link } from 'react-router-dom';
import Home from './pages/Home'
import About from './pages/About'


function App() {
  
  return (
    
    <Router>
      
      <div className="App">
      <ThemeToggle />
        <nav>
          <ul>
            <li>
              <Link to="/Home">Home</Link>
            </li>
            <li>
              <Link to="/about">About</Link>
            </li>
          </ul>
        </nav>

        <Routes>
          <Route path="/Home" element={<Home />} />
          <Route path="/about" element={<About />} />
        </Routes>
        

        {/* Other components */}
        
        
      </div>
    </Router>
  );
}

export default App;
