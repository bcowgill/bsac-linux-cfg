import styles from './my-button.module.scss';
import classNames from 'classnames';

const displayName = 'MyButton';

/*
    How to make a universal Button so that it can be styled, has focus, keyboard handling 
    and URL but looks like a button.
    Caveat: actual links do not respond to Space key up like a button does we provide onNavigateTo
    event handler for you to enable this behaviour if you want.
    Source: https://www.builder.io/blog/buttons
    https://zellwk.com/blog/style-hover-focus-active-states/
    https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Cross_browser_testing/Accessibility
 */

export interface MyButtonProps {
    'data-testid'?: string;
    className?: string;
    type?: 'button' | 'submit' | 'reset'; // use submit if it's inside a <form> and should submit the page.
    href?: string; // external/internal determined by href : matching
    target?: string;
    rel?: string; // defaults to noopener in case you are linking to an external site with target prop
    disabled?: boolean;
    onClick?: React.MouseEventHandler<HTMLButtonElement>;
    onNavigateTo?: (href: string) => void; // for Space up key support on links should -- document.location = href
    children?: React.ReactNode;
}

/**
 * This component was generated using Codux's built-in Default new component template.
 * For details on how to create custom new component templates,
 * see https://help.codux.com/kb/en/article/configuration-for-buttons-and-templates
 */
export const MyButton = ({
    className,
    disabled,
    href,
    target,
    rel = 'noopener',
    type = 'button',
    onClick,
    onNavigateTo, // a function to call document.location  = href
    children = 'Ok',
    ...props
}: MyButtonProps) => {
    const testId = props['data-testid'] || displayName;
    const asLink = href && !disabled;
    const commonProps = {
        className: classNames(asLink ? styles.link : styles.button, styles.root, className),
        disabled: disabled || !(onClick || href),
        ...props,
    };

    if (asLink) {
        const handleLinkKeyUp = (event : React.KeyboardEvent) => {
            if (event.code === 'Space' && !(event.altKey || event.metaKey) && onNavigateTo) {
                // Failure trying to dispatch an Enter keydown/keypress or onclick event.
                // https://www.geeksforgeeks.org/trigger-a-keypress-keydown-keyup-event-in-js-jquery/#:~:text=keydown%3A%20This%20event%20is%20triggered,when%20a%20key%20is%20released.
                // so we provide a navigation prop the component user can make use of which should
                // should do document.location = href;
                onNavigateTo(href); 
            }
        }

        return (
            <a
                data-testid={displayName}
                data-component={`${testId}-link`}
                href={href}
                target={target}
                rel={target && rel}
                {...commonProps}
                onKeyUp={onNavigateTo && handleLinkKeyUp}
            >
                {children}
            </a>
        );
    } else {
        return (
            <button
                data-testid={displayName}
                data-component={`${testId}-button`}
                type={type}
                onClick={onClick}
                {...commonProps}
            >
                {children}
            </button>
        );
    }
};
