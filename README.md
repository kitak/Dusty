## NAME

DustySearch - Pocketのエントリの全文検索

## 必要なミドルウェア

   - MySQL
   - Redis

## インストール
```sh
git clone https://github.com/kitak/DustySearch.git
cd DustySearch
carton install
cpanm .

# MySQLでデータベースdustyを作成し
mysql -u root dusty < db/schema.sql

# プロジェクト直下にPocketAPIのトークンの書かれたconfig.ymlを設置する
```

## コマンド
### エントリの取得
```sh
carton exec perl bin/get_html.pl N # N日前までのエントリを取得する。デフォルトは1日前まで。
```

### インデックスの作成
```sh
carton exec perl bin/indexing.pl
```

### 検索
```sh
carton exec perl bin/search.pl QUERY
```

## LICENSE

Copyright (C) Keisuke KITA.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## AUTHOR

Keisuke KITA <kei.kita2501@gmail.com>
