## 關於sein-dashboard
- 目的：希望能優化／自動化分析數據的流程，幫助編輯台和負責社群管理的夥伴使用，減少手動輸入與分析數據的時間和投入的人力，產出能幫助判讀的視覺化報表，甚至能主動提醒一些重要的決策。
- DEMO網址：www.sein.fun (預計2019/8失效)
- 專案進度可以參考[這裡](https://github.com/seinsight-ac/sein-dashboard/projects/2)
- 如果有使用上有問題可以參考[這裡](https://github.com/seinsight-ac/sein-dashboard/wiki)
- 此專案有使用gem，關於gem的使用可以參考[這裡](https://github.com/seinsight-ac/sein-dashboard/wiki/%E9%97%9C%E6%96%BCgem%E7%9A%84%E4%BD%BF%E7%94%A8)

## User Story
- [X] 使用者可以登入(一組帳密)
- [X] 使用者登入後可以看到下列資料的綜合dashboard
  - FB粉專資料
  - GA資料
  - Mailchimp資料
  - Alexa資料
- [X] 使用者可以切換標籤，看到各個不同來源資料更詳盡的dashboard
- [X] 使用者可以自由切換每個區塊週、月、季的標籤，可以看到每個區塊個別的不同時間段資料
- [ ] 使用者可以統一切換那頁的週、月、季標籤，可以看到整頁dashboard統一呈現不同時間段資料
- [ ] 使用者可以自己選取時間區段(用日曆選取幾號到幾號)，可以看到整頁dashboard呈現選取時間段的資料
- [ ] 使用者可以根據自己篩選的時間段去下載excel檔，看到更詳細的資訊

## 專案使用
- fork到自己的空間
- `git clone <自己的repo網址>`
- `cd sein-dashboard`
- `bundle install # 安裝套件`
- `rails db:migrate`
- 新增並設定config/secrets.yml檔，參考[wiki](https://github.com/seinsight-ac/sein-dashboard/wiki/%E9%97%9C%E6%96%BCsecrets.yml%E8%B3%87%E6%96%99)
- 新增並設定config/database.yml檔，參考[wiki](https://github.com/seinsight-ac/sein-dashboard/wiki/%E9%97%9C%E6%96%BCdatabase.yml%E8%B3%87%E6%96%99)
- `rails console # 創建屬於自己的使用者`可以參考[wiki](https://github.com/seinsight-ac/sein-dashboard/wiki/%E9%97%9C%E6%96%BC%E4%BD%BF%E7%94%A8%E8%80%85%E5%B8%B3%E5%AF%86)

## 作者

<a href="https://github.com/ZionYu"><img src="https://avatars0.githubusercontent.com/u/34122819?s=460&v=4" title="ZionYu" width="80" height="80"></a>
<a href="https://github.com/FunkyGary"><img src="https://avatars2.githubusercontent.com/u/30545083?s=460&v=4" title="FunkyGary" width="80" height="80"></a>
<a href="https://github.com/tsangyuwen"><img src="https://avatars0.githubusercontent.com/u/39423371?s=460&v=4" title="tsangyuwen" width="80" height="80"></a>
