import styles from './my-button.module.scss';
import classNames from 'classnames';

const displayName = 'MyButton';

/*
    How to make a universal Button so that it can be styled, has focus, keyboard handling 
    and URL but looks like a button.
    Source: https://www.builder.io/blog/buttons
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
        return (
            <a
                data-testid={displayName}
                data-component={`${testId}-link`}
                href={href}
                target={target}
                rel={target && rel}
                {...commonProps}
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
