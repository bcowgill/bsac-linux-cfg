import styles from './button.module.scss';
import classNames from 'classnames';

const displayName = 'Button';

/*
    How to make a universal Button so that it can be styled, has focus, keyboard handling 
    and URL but looks like a button.
    https://www.builder.io/blog/buttons
 */

export interface ButtonProps {
    className?: string;
    type?: 'button' | 'submit' | 'reset'; // use submit if is inside a <form> and should submit the page.
    href?: string;
    target?: string;
    rel?: string; // defaults to noopener in case you are linking to an external site with target prop
    disabled?: boolean;
    onClick?: React.MouseEventHandler<HTMLButtonElement>;
    children?: React.ReactNode;
}

/**
 * This component was generated using Codux's built-in Default new component template.
 * For details on how to create custom new component templates, see https://help.codux.com/kb/en/article/configuration-for-buttons-and-templates
 */
export const Button = ({
    className,
    disabled,
    href,
    target,
    rel = 'noopener',
    type = 'button',
    onClick,
    children = 'Ok',
    ...props
}: ButtonProps) => {
    const asLink = href && !disabled;
    const common = {
        className: classNames(asLink ? styles.link : styles.button, styles.root, className),
        disabled: disabled || !(onClick || href),
        ...props,
    };
    if (asLink) {
        return (
            <a
                data-testid={displayName}
                href={href}
                target={target}
                rel={target && rel}
                {...common}
            >
                {children}
            </a>
        );
    } else {
        return (
            <button data-testid={displayName} type={type} onClick={onClick} {...common}>
                {children}
            </button>
        );
    }
};
