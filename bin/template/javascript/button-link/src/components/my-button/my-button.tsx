import styles from './my-button.module.scss';
import classNames from 'classnames';

/*
    How to make a universal Button so that it can be styled, has focus, keyboard handling 
    and URL but looks like a button.
    https://www.builder.io/blog/buttons
 */

export interface MyButtonProps {
    className?: string;
    type?: "button" | "submit" | "reset"; // use submit if is inside a <form> and should submit the page.
    href?: string;
    target?: string;
    disabled?: boolean;
    onClick?: React.MouseEventHandler<HTMLButtonElement>;
    children?: React.ReactNode;
}

/**
 * This component was generated using Codux's built-in Default new component template.
 * For details on how to create custom new component templates, see https://help.codux.com/kb/en/article/configuration-for-buttons-and-templates
 */
export const MyButton = ({ className, disabled, href, target, type = 'button', onClick, children = 'Ok', ...props }: MyButtonProps) => {
    const asLink = href && !disabled;
    const common = {
        className: classNames(asLink ? styles.link : styles.button, styles.root, className),
        disabled: disabled || !(onClick || href),
        ...props
    };
    if (asLink)
    {
        return (<a href={href} target={target} {...common}>{children}</a>);
    }
    else
    {
        return (<button type={type} onClick={onClick} {...common}>{children}</button>);
    }
};
