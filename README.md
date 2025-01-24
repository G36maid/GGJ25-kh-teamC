
# **遊戲名稱**: **信件指揮官：泡泡防線(暫定)**

> GGJ25-kh-teamC
---

## **遊戲發想**  
《信件指揮官：泡泡防線》是一款融合塔防與策略的遊戲，玩家將扮演一名在戰場總部（HQ）指揮作戰的指揮官，透過信件系統（命令行）調度資源與哨站，共同對抗來襲的泡泡大軍。  

### **遊戲特色**  
- **創新玩法**：透過信件命令調度資源、管理前哨站並指揮戰鬥。  
- **戰場模擬**：玩家無法直接觀察戰場，只能依賴 HQ 的雷達掃描數據與信件交流。  
- **資源管理**：靈活分配食物、彈藥和材料，確保前哨站持續運作並成功抵禦敵人進攻。  
- **通關目標**：防守住固定波次的泡泡攻勢，守住戰場的最後防線。  

---

## **遊戲機制**  

### **地圖與視覺分佈**  

1. **戰場**  
     - 矩形地圖，敵人會沿固定路徑從上方進攻至下方。
     - 每條路徑都有一個前哨站，具有攻擊能力、防禦能力與血量。 
         - 每條路徑的哨站與指揮中心的距離不同 
     - 哨站需要消耗資源（如彈藥）來進行防禦與攻擊。  
  
2. **指揮中心 (HQ)**   
   - **左半邊畫面**：  
     - 玩家無法直接看到戰場，而是依靠定期掃描的雷達圖獲取敵人、哨站與郵差的位置資訊。，以及我方哨站的資源概況。
   - **右半邊畫面**：
     - 玩家在這裡通過編輯器撰寫信件指令，指揮郵差運送資源和發出命令。

---

### **核心操作：信件系統**  
玩家透過簡單的命令語法撰寫信件，來調度郵差和資源。以下是信件支援的基本指令語法：  

#### **語法格式**  
```plaintext
from X to Y             # 指定從 X 點到 Y 點運送物資。
grab (資源) (數量)     # 從指定位置提取資源。
drop (資源) (數量)     # 在指定位置投放資源。
from any to base        # 回到指揮中心（預設行為）。
```  

#### **資源種類**  
- **食物**：恢復哨站的血量，或提升攻擊效率。  
- **彈藥**：供應哨站武器，沒有彈藥則無法攻擊。  
- **材料**：用於提升防禦、修復哨站或建造新設施。  

---

### **資源獲取方式**  
1. **敵人掉落**  
   - 當敵人在哨站附近被消滅時，會掉落特定資源，該行的哨站會自動蒐集。  

2. **HQ 補給**  
   - 指揮中心會定期生成少量物資，玩家可以分配這些物資給前線哨站。  

---

### **靈感參考**  
本遊戲受以下經典作品啟發：  
- **Radio Commander**：雷達與指揮模式的核心靈感來源。  
- **Plants vs. Zombies**：矩形塔防戰場與波次進攻設計的參考。  

![參考圖示](https://i.ytimg.com/vi/JghTQXQ2toI/maxresdefault.jpg)  

---

### **未來規劃**  
1. **更多地圖與挑戰**：增加不同地形和更高難度的敵人波次。  
2. 更多敵人類型
3. 更多彈藥與資源種類
