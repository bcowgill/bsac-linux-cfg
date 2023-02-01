import { createBoard } from '@wixc3/react-board';
import { Button } from '../../../components/button/button';

const SOURCE = 'https://www.builder.io/blog/buttons'

const URL = (label: string) => `http://duckduckgo.com?q=you clicked the link for ${label}`;

const cell: React.CSSProperties = {
    padding: '0.3em 0.5em',
};

const left: React.CSSProperties = {
    textAlign: "left",
    ...cell,
};

const right: React.CSSProperties = {
    textAlign: "right",
    ...cell,
};

function handleClick() {
    alert("You clicked the button")
}

export interface TDProps {
    colSpan?: number,
    children: React.ReactNode,
}

function TD({ children, ...props } : TDProps) {
    return <td style={right} {...props}>{children}</td>
}

function TH({ children, ...props } : TDProps) {
    return <th style={left} {...props}>{children}</th>
}

export default createBoard({
    name: 'Button',
    Board: () => (<div>
        <table>
            <thead>
                <tr><td colSpan={2}>
                    <h4>Smart Browser Button or Link based on onClick or href properties with full UX accessibility etc.</h4>
                    <p><Button href={SOURCE}>{SOURCE}</Button></p>
                </td></tr>
            </thead>
            <tbody>
                <tr><TD><Button>Disabled</Button></TD><TH>no onClick or href ➡ disabled</TH></tr>
                <tr><TD><Button onClick={handleClick}/></TD><TH>with onClick ➡ uses &lt;button&gt; with all focus, accessibility etc.</TH></tr>
                <tr><TD><Button disabled onClick={handleClick}>Force Disabled</Button></TD><TH>onClick with disabled prop</TH></tr>
                <tr><TD><form>&lt;form …&gt;<Button type="submit" onClick={handleClick}>Submit</Button>&lt;/form&gt;</form></TD><TH>type=submit when inside a &lt;form&gt;</TH></tr>
                <tr><TD colSpan={2}><hr/></TD></tr>
                <tr><TD><Button href={URL('as Link')} target="_blank">as Link</Button></TD><TH>with href _blank ➡ uses &lt;a&gt; instead of button for url history</TH></tr>
                <tr><TD><Button href={URL('as Link with target')} target="panel">as Link with target</Button></TD><TH>with href and target=panel ➡ uses &lt;a&gt; instead of button for url history</TH></tr>
                <tr><TD><Button disabled href={URL('disabled')} target="_blank">Force Disabled as Link</Button></TD><TH>href with disabled prop</TH></tr>
            </tbody>
            <tfoot>
                <tr><td colSpan={2}>
                    <p>Manually check usability / accessibility by tab, mouse hover, mouse down/up and keyboard Space/Enter</p>
                </td></tr>
            </tfoot>
        </table>
    </div>)
});
