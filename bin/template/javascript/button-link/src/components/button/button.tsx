import styles from './button.module.scss';
import classNames from 'classnames';

const displayName = 'Button';

const external = '\u2b08'; // ⬈	U+2B08	[OtherSymbol]	NORTH EAST BLACK ARROW
const internal = '\u27a1 '; // ➡	U+27A1	[OtherSymbol]	BLACK RIGHTWARDS ARROW

const buttonClass = styles.button;

/*
    How to make a universal Call To Action that looks like a Link if href URL given otherwise looks like a Button.
    Marks links with an arrow if internal or a diagonal up arrow if it takes you externally to a new site/window.
    Source: https://www.builder.io/blog/buttons
 */

export interface ButtonProps {
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

const Internal = () => {
    return <span className={classNames(styles.arrow)}>{internal}</span>
}

const External = () => {
    return <span className={classNames(styles.above)}>{external}</span>
}

/**
 * This component was generated using Codux's built-in Default new component template.
 * For details on how to create custom new component templates,
 * see https://help.codux.com/kb/en/article/configuration-for-buttons-and-templates
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
    const testId = props['data-testid'] || displayName;
    const asLink = href && !disabled;
    const isExternal = href && (target || /^\w+:/.test(href));
    
    const commonProps = {
        className: classNames(asLink ? styles.link : buttonClass, styles.root, className),
        disabled: disabled || !(onClick || href),
        ...props,
    };

    if (asLink) {
        return (
            <>
                {isExternal ? '' : <Internal
                    data-testid={`${testId}-link-internal`}
                    />}
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
                {isExternal && <External 
                    data-testid={`${testId}-link-external`}
                    />}
            </>
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
