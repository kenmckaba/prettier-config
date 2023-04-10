# `@bluejeans/prettier-config`

> Bluejeans standard [Prettier](https://prettier.io) config.

Using the approach suggested by https://prettier.io/docs/en/configuration.html#sharing-configurations

See all prettier options and their defaults: https://prettier.io/docs/en/options.html

The options herein are commonly used in modern code.

* [trailingComma](https://prettier.io/docs/en/options.html#trailing-commas): "all"<br>
This will add a trailing comma to each entry in a list of parameters. This way if you add or remove a parameter `git diff` won't show the previous line has changed.

```js
foo(
  first, // if you delete the next line, this one won't change
  second, // if you add a line below, this one won't change
)
```

* [singleQuote](https://prettier.io/docs/en/options.html#quote-props): true<br>
All strings will use single quotes.

* [semi](https://prettier.io/docs/en/options.html#semicolons): false<br>
Line ends won't end with a semicolon, except where necessary.


## Usage

**Install**:

```bash
$ yarn add --dev @bluejeans/prettier-config
```

**Edit `package.json`**:

```jsonc
{
  // ...
  "prettier": "@bluejeans/prettier-config"
}
```
