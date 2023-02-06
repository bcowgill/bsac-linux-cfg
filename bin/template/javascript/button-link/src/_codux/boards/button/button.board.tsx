import { createBoard } from '@wixc3/react-board';
import { Button, ButtonProps } from '../../../components/button/button';

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

function VButton(props: ButtonProps) {
    return <div><Button {...props} /></div>
}

function Ok() {
    return <Button onClick={handleClick} />
}

function Internal() {
    return <Button href="/" />
}

function VOk() {
    return <VButton onClick={handleClick} />
}

function VInternal() {
    return <VButton href="/" />
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
                <tr><TD><Button data-testid="TESTID">Disabled</Button></TD><TH>no onClick or href ➡ disabled</TH></tr>
                <tr><TD><Ok /><Ok /></TD><TH>with onClick ➡ uses &lt;button&gt; side-by-side with all focus, accessibility etc.</TH></tr>
                <tr><TD>
                    <VOk />
                    <VOk />
                </TD><TH>with onClick ➡ uses &lt;button&gt; vertically with all focus, accessibility etc.</TH></tr>
                <tr><TD><Button disabled onClick={handleClick}>Force Disabled</Button></TD><TH>onClick with disabled prop</TH></tr>
                <tr><TD><form>&lt;form …&gt;<Button type="submit" onClick={handleClick}>Submit</Button>&lt;/form&gt;</form></TD><TH>type=submit when inside a &lt;form&gt;</TH></tr>
                <tr><TD colSpan={2}><hr/></TD></tr>
                <tr><TD><Button href="/">Internal Link</Button></TD><TH>with href internal ➡ uses arrow with &lt;a&gt; instead of button for url history</TH></tr>
                <tr><TD><Button href={URL('as External Link')}>External Link</Button></TD><TH>with href external site ➡ uses &lt;a&gt; with external icon</TH></tr>
                <tr><TD><Button href="mailto:....">MailTo Link</Button></TD><TH>with href as mailto ➡ uses &lt;a&gt; with external icon</TH></tr>
                <tr><TD><Button href={URL('as Link with target')} target="panel">as Link with target</Button></TD><TH>with href and target=panel ➡ uses &lt;a&gt; with external icon</TH></tr>
                <tr><TD><Button disabled href={URL('disabled')} target="_blank">Force Disabled as Button</Button></TD><TH>href with disabled prop</TH></tr>
                <tr><TD>
                    <Internal />
                    <Button href={URL('side by side links')}/>
                </TD><TH>side-by-side links</TH></tr>
                <tr><TD>
                    <Button href={URL('side by side links and buttons')}/>
                    <Ok />
                    <Button href={URL('side by side buttons and links')}/>
                    <Internal />
                    <Ok />
                    <Internal />
                </TD><TH>side-by-side buttons and links</TH></tr>
                <tr><TD>
                    <VInternal />
                    <VButton href={URL('vertical links')}/>
                </TD><TH>vertical links</TH></tr>
                <tr><TD>
                    <VButton href={URL('vertical links and buttons')}/>
                    <VOk />
                    <VButton href={URL('vertical buttons and links')}/>
                    <VInternal />
                    <VOk />
                    <VInternal />
                </TD><TH>vertical buttons and links</TH></tr>
            </tbody>
            <tfoot>
                <tr><td colSpan={2}>
                    <p>Manually check usability / accessibility by tab, mouse hover, mouse down/up and keyboard Space/Enter</p>
                </td></tr>
            </tfoot>
        </table>
    </div>)
});
