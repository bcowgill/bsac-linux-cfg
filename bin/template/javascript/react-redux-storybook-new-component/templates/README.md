# React Component Template Files

Create new React/Redux/Storybook/Jest files by copying and replacing from templates.  See also ../scripts/new.pl

## Pure Component - Unit - Story

When creating a pure component which you want to both unit and story test:

```
COMPONENT=comp-name
WHERE=src/components/SUBDIR/$COMPONENT
cp templates/component.pure.jsx         $WHERE/$COMPONENT.jsx
cp templates/component.factory.spec.jsx $WHERE/$COMPONENT.spec.jsx
cp templates/component.factory.jsx      $WHERE/$COMPONENT.factory.jsx
cp templates/component.stories.js       $WHERE/$COMPONENT.stories.js
cp templates/facade-index.js            $WHERE/index.js
```

Then search and replace TEMPLATE in these files for the appropriate component name or path: comp-name or CompName or SUBDIR

## Stateful Component - Unit - Story

For a non-pure component do the same but use this first:

```
cp templates/component.jsx  $WHERE/$COMPONENT.jsx
```

## Pure Component - Unit

If you are only going to unit test a pure component:

```
COMPONENT=comp-name
WHERE=src/components/SUBDIR/$COMPONENT
cp templates/component.pure.jsx  $WHERE/$COMPONENT.jsx
cp templates/component.spec.jsx  $WHERE/$COMPONENT.spec.jsx
cp templates/facade-index.js     $WHERE/index.js
```

## Component Facade - Unit

If you are unit testing a component Facade file:

```
COMPONENT=comp-name
WHERE=src/components/SUBDIR/$COMPONENT
cp templates/facade.component.spec.js  $WHERE/index.spec.js
```

## Non-component Facade - Unit

If you are unit testing a non-component Facade file:

```
UTIL=util-name
WHERE=src/SUBDIR/$UTIL
cp templates/facade.spec.js  $WHERE/index.js
```

## Non-component - Unit

If you are unit testing a non-component utility or class file:

```
UTIL=util-name
WHERE=src/SUBDIR/$UTIL
cp templates/simple.spec.js  $WHERE/$UTIL.spec.js
```
