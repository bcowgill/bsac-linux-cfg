import { createBoard } from '@wixc3/react-board';
import { MyButton as Button } from '../../../components/my-button/my-button';

function handleClick() {}
    
export default createBoard({
    name: 'MyButton',
    Board: () => (<div>
        <h4>Styled as Button always with onClick or href properties to use &lt;button&gt; or &lt;a&gt; underneath</h4>
        <table><tbody>
        <tr><td><Button>Disabled</Button></td><th>no onClick or href == disabled</th></tr>
        <tr><td><Button onClick={handleClick}/></td><th>with onClick == uses &lt;button&gt; with all focus, accessibility etc.</th></tr>
        <tr><td><Button disabled onClick={handleClick}>Force Disabled</Button></td><th>onClick with disabled prop</th></tr>
        <tr><td><Button href="#" target="_blank">as Link</Button></td><th>with href == uses &lt;a&gt; but still looks like our button style</th></tr>
        <tr><td><Button disabled href="#" target="_blank">Force Disabled as Link</Button></td><th>href with disabled prop</th></tr>
        <tr><td><form><Button type="submit" onClick={handleClick}>Submit</Button></form></td><th>type=submit when inside a &lt;form&gt;</th></tr>
    </tbody></table></div>)
});
