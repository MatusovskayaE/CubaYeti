(() => {
  let clck = hmFS.SysProGetInt("ClickCount");
  if(!clck) clck = 0;

    let __$$app$$__ = __$$hmAppManager$$__.currentApp;
  let __$$module$$__ = __$$app$$__.current;
  __$$module$$__.module = DeviceRuntimeCore.Page({
    onInit() {

      const img_hour = hmUI.createWidget(hmUI.widget.IMG)
      img_hour.setProperty(hmUI.prop.MORE, {
        x: 50,
        y: 260,
        src: "WhiteYeti1.png",
      })
  
  
      const text = hmUI.createWidget(hmUI.widget.TEXT, {
        x: 0,
        y: 90,
        w: 192,
        h: 290,
        color: 0xffffff,
        text_size: 50,
        align_h: hmUI.align.CENTER_H,
        align_v: hmUI.align.CENTER_V,
        text_style: text_style.WRAP,
        text: clck
      })

      hmUI.createWidget(hmUI.widget.BUTTON, {
        x: (192 - 80) / 2,
        y: 160,
        w: 80,
        h: 40,
        radius: 12,
        normal_color: 0x0057fa,
        press_color: 0x8ac8ff,
        text: 'Reset',
        click_func: () => {
          clck = 0;
          text.setProperty(hmUI.prop.MORE, {
            text: clck
          });
        }
      })


      
      hmUI.createWidget(hmUI.widget.BUTTON, {
        x: (192 - 192) / 2,
        y: 350,
        w: 192,
        h: 140,
        radius: 0,
        text_size: 60,
        normal_color: 0x8ac8ff,
        press_color: 0xbde0ff,
        text: '+',
        click_func: () => {
          clck = clck + 1;
          text.setProperty(hmUI.prop.MORE, {
            text: clck
          });
        }
      })
            
      hmUI.createWidget(hmUI.widget.BUTTON, {
        x: (192 - 192) / 2,
        y: 0,
        w: 192,
        h: 140,
        radius: 0,
        text_size: 100,
        normal_color: 0x8ac8ff,
        press_color: 0xbde0ff,
        text: '-',
        click_func: () => {
          if(clck>0) {
          clck = clck - 1;
          };
          text.setProperty(hmUI.prop.MORE, {
            text: clck
          });
        }
      })

  
  
  
    },
    onDestroy() {
  
      hmFS.SysProGetInt("ClickCount", clck);
  
    }
  });
})();