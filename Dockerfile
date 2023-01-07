ARG GCC_IMAGE_TAG
FROM gcc:$GCC_IMAGE_TAG

# パッケージ更新＆追加
RUN apt-get update
RUN apt-get install -y vim git git-secrets ffmpeg 

# パラメータ変数
ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
ARG WORKDIR
ARG TIMEZONE
ARG MODEL_TYPE
ARG AUDIO_FILE_DIR
ARG TRANS_FILE_DIR
 
# 環境変数
ENV AUDIOFILEPATH=/var/tmp/$AUDIO_FILE_DIR
ENV TRANSFILEPATH=/var/tmp/$TRANS_FILE_DIR

# タイムゾーン設定
ENV TZ $TIMEZONE

# ユーザー追加
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

# ルートフォルダ作成
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

# リソース取得
RUN git clone https://github.com/ggerganov/whisper.cpp.git
# 権限変更
RUN chown -R $UID:$GID $WORKDIR/whisper.cpp

# ファイル参照フォルダ作成
RUN mkdir -p $AUDIOFILEPATH
RUN mkdir -p $TRANSFILEPATH
# 権限変更
RUN chown -R $UID:$GID $AUDIOFILEPATH
RUN chown -R $UID:$GID  $TRANSFILEPATH


# ユーザー切り替え
USER $USERNAME

# 作業ディレクトリ設定
WORKDIR $WORKDIR/whisper.cpp

# 文字起こしファイルコピー
COPY transcribe.sh ./

# モデルダウンロード
RUN bash ./models/download-ggml-model.sh $MODEL_TYPE

# コンパイル
RUN make
