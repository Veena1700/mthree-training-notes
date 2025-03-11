import React, { useState } from 'react';
function ThemeToggle() {
    const [theme, setTheme] = useState('light');
    const toggleTheme = () => {
        setTheme(theme === 'light' ? 'dark' : 'light');
    };
    return (
        <button onClick={toggleTheme}>
            {theme === 'light' ? 'Dark Mode' : 'Light Mode'}
            <style jsx>{`
                body {
                    background-color: ${theme === 'light' ? 'white' : '#333333'};
                    color: ${theme === 'light' ? 'black' : 'white'};
                }
            `}</style>
            
            </button>
    );
}
export default ThemeToggle;