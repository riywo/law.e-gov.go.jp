law.e-gov.go.jp
===============

総務省の[法令データ提供システム](http://law.e-gov.go.jp/cgi-bin/idxsearch.cgi)から全法令をダウンロードしてgithubに上げてみました。

上記のサイトは１ヶ月に１回更新されるので、１ヶ月に１回全件取得して`git commit & push`する想定です。

    $ rm -fr data
    $ ruby download.rb
    $ git add -A
    $ git commit
    $ git push

もうちょっといい感じにしてくれる方がいれば、ぜひご協力下さい。

Licence
=================

特に二次利用制限は無いとのことなので、ダウンロードしたものをそのままアップロードしています。もし権利上問題があるということであれば削除します。

References
===================

- ["翻訳" ドイツ連邦の法律がGitHubで管理される | ntcncp.net](http://ntcncp.net/2012/12/22/german-federal-law-on-github)
