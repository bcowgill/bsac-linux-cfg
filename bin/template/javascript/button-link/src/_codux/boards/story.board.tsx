import { useState } from 'react';
import { createBoard } from '@wixc3/react-board';
import { Button, ButtonProps } from '../../components/button/button';

/*
    A Codux Board which is a bit more similar to a Storybook component tester.
*/

const clickMe = () => alert("You clicked the button")
const URL = (label: string) => `http://duckduckgo.com?q=you clicked the link for ${label}`;

const Stories = {
    Default: { _info: 'defaults to disabled button with Ok as text' },
    Disabled: {
        _info: 'no onClick or href ➡ disabled',
        'data-testid': "TESTID",
        children: 'Disabled'
    },
    ForceDisabled: {
        _info: 'onClick with disabled prop',
        disabled: true,
        children: 'Force Disabled',
        onClick: clickMe
    },
    asButton: {
        _info: 'with onClick ➡ uses <button> with all focus, accessibility etc.',
        onClick: clickMe
    },
    asSubmitInsideForm: {
        _info: 'type=submit when inside a <form>',
        type: 'submit',
        children: 'Submit',
        onClick: clickMe
    },
    asInternalLink: {
        _info: 'with href internal ➡ uses arrow with <a> instead of button for url history',
        href: '#',
        children: 'Internal Link'
    },
    asExternalLink: {
        _info: 'with href external site ➡ uses <a> with external icon',
        href: URL('External Link'),
        children: 'External Link'
    },
    asMailToLink: {
        _info: 'with href as mailto: ➡ uses <a> with external icon',
        href: 'mailto:...',
        children: 'MailTo Link'
    },
    asLinkWithTarget: {
        _info: 'with href and target=panel ➡ uses <a> with external icon',
        href: URL('as Link with target'),
        target: 'panel',
        children: 'as Link with target'
    },
    asDisabledWithHref: {
        _info: 'href with disabled prop',
        href: URL('as disabled Link'),
        disabled: true,
        children: 'Force Disabled as Button'
    }
};

const DEFAULT = 'Default';
const CLOSE = '^'
const OPEN = 'v'
const SHOW_MENU : React.CSSProperties = { display: 'inherit', visibility: 'inherit' }
const HIDE_TITLE : React.CSSProperties = { transform: 'scale(0.5)' }
const HIDE_MENU : React.CSSProperties = { display: 'none', visibility: 'hidden' }

interface StoryBoardProps
{
    stories?: typeof Stories,
    Component?: typeof Wrapper,
}

interface StoryMenuProps
{
    componentName: string,
    currentStory: string,
    storyNames: string[],
    onChangeMode: (name: string) => void
}

interface StoryMenuItemProps
{
    currentStory: string,
    thisStory: string,
    onClick: React.MouseEventHandler<HTMLElement> 
}

function toModeTitle(name: string) : string
{
    return name.replace(/([a-z])([A-Z])/g, "$1 $2")
}

const StoryMenuItem = ({ currentStory, thisStory, onClick } : StoryMenuItemProps) =>
{
    const title = toModeTitle(thisStory)

    return (
        <li key={thisStory}>
            {thisStory === currentStory 
                ? <big><b>{title}</b></big>
                : <button onClick={onClick}><small>{title}</small></button>
            }
        </li>)
}

const StoryMenu = ({ componentName, currentStory, storyNames, onChangeMode } : StoryMenuProps) =>
{
    const [open, setOpen] = useState(false)
    const show = open ? SHOW_MENU : HIDE_MENU;
    const title = open ? void 0 : HIDE_TITLE;

    function handleOpenerClick() {
        setOpen(!open)
    }

    return (<>
        <h4 style={title} onClick={handleOpenerClick}>{componentName} Component Modes: <button onClick={handleOpenerClick}>{open ? CLOSE : OPEN}</button></h4>
        <ul style={show}>
            {storyNames.map(function renderStoryNames(name) {
                return (
                    <StoryMenuItem key={name} currentStory={currentStory} thisStory={name} onClick={() => onChangeMode(name)} />
                )
            })}
        </ul>
        </>
    )
}

const StoryBoard = ({stories = Stories, Component = Wrapper} : StoryBoardProps) => {
    const storyNames = Object.keys(stories)
    if (!storyNames.length)
    {
        storyNames.push(DEFAULT)
    }
    const [storyName, setStoryName] = useState(storyNames[0])

    const props = stories[storyName as keyof typeof Stories] || {}

    return (
        <div>
            <div><Component {...props} /></div>
            <StoryMenu
                componentName={Component.name}
                currentStory={storyName}
                storyNames={storyNames}
                onChangeMode={setStoryName}
            />
        </div>)
}

const SOURCE = 'https://www.builder.io/blog/buttons'

interface WrapperProps
{
    _info?: string
}

const Wrapper = ({_info, ...props}: WrapperProps) =>
{
    return (<>
        <div>
            <h4>Smart Browser Button or Link based on onClick or href properties with full UX accessibility etc.</h4>
        </div>
        <div><Button {...props} /></div>
        {_info && <div><p><i>{_info}</i></p></div>}
        <div>
            <p>Manually check usability / accessibility by tab, mouse hover, mouse down/up and keyboard Space/Enter</p>
            <p>Source: <Button href={SOURCE}>{SOURCE}</Button></p>
        </div>
    </>)
}

export default createBoard({
    name: 'Story',
    Board: () => (<div><StoryBoard Component={Wrapper}/></div>)
});

