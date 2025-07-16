# Mac_環境
- 備忘録です．

<details>
<summary>基本</summary>
Macでのインストールは基本

`brew install XXX` でどうにかなる．
</details>

---
# CRDのキーボード設定
2025-07-16<br>
Chrome Remoto Desktop(CRD)でWindows10をMacから操作するときのキーボード設定．
1. Windowsの設定(キーの割当設定)<br>
    時刻と言語 > 言語 > 日本語 > オプション
    - レイアウト > **日本語キーボード(106/109キー)**　(PC再起動必須?)
    - キーボード > Microsoft IME > オプション > キーとタッチのカスタマイズ > キーの割り当て
      | 設定 | 推奨 |
      | --- | --- |
      | 無変換キー | **IME-オフ（または IMEオン/オフ）** |
      | 変換キー | **IME-オン** |
2. Karabineerの設定(Mac側のキー送り調整)<br>
   Karabineerで Eisu→F13，Kana→F14 に変更(CRD起動時のみの変換)
    - CRDにキーが送られる前にMac側で変換キーとして消費されるため．
    - アプリのID↓は環境ごとに違うはずなので，KarabineerのEventViewerで調べる必要あり．
      "com.google.Chrome.app.cmkncekebbebpfilplodngbpllndjkfo"
```
{
    "description": "Eisu→F13, Kana→F14 (only CRD window)",
    "manipulators": [
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "com.google.Chrome.app.cmkncekebbebpfilplodngbpllndjkfo"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "japanese_eisuu" },
            "to": [{ "key_code": "f13" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "com.google.Chrome.app.cmkncekebbebpfilplodngbpllndjkfo"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "japanese_kana" },
            "to": [{ "key_code": "f14" }],
            "type": "basic"
        }
    ]
}
```

3. CRDの設定(Mac→Windowsでの変換設定)<br>
   CRDのサイドパネル(初期設定は右) > キーマッピングの設定
    - 以下のように設定すると，基本はMacと同じ操作感になる．
    - Windowsキーは右⌘(MetaRight)になっている．
      | マッピング元のキー | マッピング先のキー |
      | --- | --- |
      | F13 | NonConvert |
      | F14 | Convert |
      | MetaLeft | ControlLeft |


---
# Hammerspoon　" ウィンドウ操作 "
init.luaを以下のディレクトリにコピーすると，コマンドが使えるようになる．

`/Users/ユーザー名/.hammerspoon/init.lua`

<details>
<summary>コマンド</summary>

1. ショートカット：Ctrl + Option + Command + →　で右モニターに送る
2. ショートカット：Ctrl + Option + Command + ←　で左モニターに送る
3. ショートカット：Command + ろ でGUIメニューを起動  
- ウィンドウの配置をGUIメニューから選択

    - `　中央に配置　`

    - ```
        　1枚目ウィンドウ ■　　2/3
        ■■□　□□
        ■■□　□●
        ■■□　□●
        　2枚目ウィンドウ ●　　2/3 * 1/2
        ```
    - `　■□　□●　1枚目ウィンドウ ■　 1/2左寄せ `
    - `　●□　□■　1枚目ウィンドウ ■　 1/2右寄せ `
    - `　■■□　□□●　1枚目ウィンドウ ■　 2/3左寄せ `

</details>


- Reload Configをしないと反映されない
- ステージマネージャーと併用すると良い
- デスクトップは一つのモニターで3つまでがよい
- `トラックパッド > フルスクリーンアプリケーションをスワイプ　> 4本指で左右にスワイプ`をONにして上下左右にスライドすると感動する
