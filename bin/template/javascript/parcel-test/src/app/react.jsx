   import './styles.scss';
   import React from 'react';
   import ReactDOM from 'react-dom';

   const App = () => (
	  <h1>Hello ALL from React and parcel!</h1>
   );
   App.displayName = 'App';

   const rootDiv = document.getElementById( 'root' );
   ReactDOM.render( <App />, rootDiv );
