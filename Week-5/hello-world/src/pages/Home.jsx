import React from 'react';
import Component1 from './../components/Component1';
import Counter from './../components/Counter'

function Home() {
    return (
        <div>
            <h1>Home</h1>
            <Component1 />
            <Counter />
        </div>
    );
}

export default Home;