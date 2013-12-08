law.e-gov.go.jp
===============

総務省の[法令データ提供システム](http://law.e-gov.go.jp/cgi-bin/idxsearch.cgi)から全法令をダウンロードしてgithubに上げてみました。

上記のサイトは１ヶ月に１回更新されるので、１ヶ月に１回全件取得して`git commit & push`する想定です。
```shell
    $ rm -fr data
    $ ruby download.rb
    $ git add -A
    $ git commit
    $ git push
```
もうちょっといい感じにしてくれる方がいれば、ぜひご協力下さい。


Install
======
bundlerを使って、インストールを楽にする。

bunderを導入したあと
```shell
$bundle install --path vendor/bundle
```
で必要なデータが入ります。
```shell
$bundle exec ruby download data2
```
でデータのダウンロードを行います。

Option
=======

```shell
$bundle exec ruby download  data3  --hash #hash オプション
```

ファイル名をハッシュにする(unixだと、日本語のファイル名が、Too Long file nameになるので)。
downloadedファイルには、タブ区切りで、hash化した法令名、法令名、事例カテゴリの順にデータが入ってます。

Licence
=================

特に二次利用制限は無いとのことなので、ダウンロードしたものをそのままアップロードしています。もし権利上問題があるということであれば削除します。

References
===================

- ["翻訳" ドイツ連邦の法律がGitHubで管理される | ntcncp.net](http://ntcncp.net/2012/12/22/german-federal-law-on-github)
