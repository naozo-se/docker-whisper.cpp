# docker-whisper.cpp

# 実行方法 (.env を変更していない場合)
- カレントディレクトリで コンテナを立てます
```
docker-compose up -d --build
```

- audio-files のフォルダが作成されるので、直下に音声ファイルをおく

- 以下のコマンドを実行して、文字起こし処理を実行
```
docker exec -ti {コンテナ名} bash transcribe.sh
```

- trans-files 以下のフォルダにテキストファイルが作成されている

