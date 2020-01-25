# My SDL2 warehouse

## Requires

sdl2, sdl2_image

## c

```
$ make SRCS=ファイル.c
$ ./app
```

## nim

Nimでは`sdl2`と`sdl2nim`がありますが、後者のほうを使います。

```
$ nimble install sdl2nim
```

コンパイルは

```
$ make SRCS=ファイル.nim
```
コンパイラオプションは各自のお好みで。

## rust

stepNのNの部分は各ステップの番号と置き換えて実行します。

自動で終了するものもありますが、ウィンドウのXをクリックすれば終了できます。

```
$ cargo run --bin stepN
```
