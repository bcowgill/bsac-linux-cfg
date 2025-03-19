console.log("Hello via Cross Bun!", Bun.version);
function Component(props) {
    return (<body>
      <h1 style={{ color: 'red' }}>{props.message}</h1>
    </body>);
}
console.log(<Component message="Hello world!"/>);
