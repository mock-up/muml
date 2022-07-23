# muml.nim

[mock up](https://github.com/mock-up/mock-up)に対してレンダリングする動画構成を規定するための中間言語。

## Element
デフォルトでは`video`、`image`、`audio`、`shape`、`text`の5つがあります。  
`addTag`テンプレートによってTagを実装できます。

```nim
addTag()
```

## Attribute
TagはそれぞれPropertyを持っています。  
`addProperty`テンプレートによってPropertyを実装できます。

## Data
PropertyはいくつかDataを持っています。  
`addData`テンプレートによってDataを実装できます。