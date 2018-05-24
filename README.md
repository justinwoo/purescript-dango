# PureScript-Dango

A fun library for sized lists in PureScript 0.12 using Symbols

![](https://i.imgur.com/zAAgsSN.jpg)

## Usage

```hs
main :: Effect Unit
main = do
  log "Empty"
  let (empty :: D.SizedList "" Int) = D.empty
  logShow empty

  log "Singleton"
  let
    -- inferred:
    -- (b :: SizedList "." Int)
    singleton
      = D.singleton 1
  logShow singleton

  log "toList of singleton"
  let list = D.toList singleton
  logShow list

  log "toList of singleton"
  let nonEmptyList = D.toList singleton
  logShow nonEmptyList

  log "head of singleton"
  let head = D.head singleton
  logShow head

  -- correct compile error:
  -- let head' = D.head empty

  log "tail of singleton"
  let
    -- inferred
    -- (tail :: SizedList "" Int)
    tail
      = D.tail singleton
  logShow tail

  -- correct compile error:
  -- let tail' = D.tail empty

  log "append two singletons"
  let
    -- inferred
    -- (append :: SizedList ".." Int)
    append
      = D.append singleton singleton
  logShow append

  log "Finished"
```
