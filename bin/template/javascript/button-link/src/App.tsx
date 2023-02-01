import logo from './assets/logo.svg';
import styles from './App.module.scss';
import { MyButton } from './components/my-button/my-button';

function handleClick() {
    alert("You clicked the button!")
}

function VOk() {
    return <div><MyButton onClick={handleClick} /></div>
}

function VLink() {
    return <div><MyButton href="/">Ok</MyButton></div>
}

function App() {
    return (
        <div className={styles.App}>
            <header className={styles['App-header']}>
                <img src={logo} className={styles['App-logo']} alt="logo" />
                <p>
                    Edit <code>src/App.tsx</code> and save to reload.
                </p>
                <a
                    className={styles['App-link']}
                    href="https://reactjs.org"
                    target="_blank"
                    rel="noopener noreferrer"
                >
                    Learn React
                </a>
                <div style={{padding: '1rem'}}>
                    <VLink />
                    <VOk />
                    <VLink />
                    <VOk />
                    <VOk />
                    <VOk />
                </div>
            </header>
        </div>
    );
}

export default App;
