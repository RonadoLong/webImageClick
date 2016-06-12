//
//  image.js
//  Floral
//
//  Created by  on 16/5/7.
//  Copyright © 2016年 ALin. All rights reserved.
//

//setImage的作用是为页面的中img元素添加onClick事件，即设置点击时调用imageClick


window.onload(getAllImageUrl())


//image click load urlimage
function imageClick(i){
    var rect = getImageRect(i);
    var url = "imageClick::"+i+"::"+rect;
    document.location = url;
}

//get image rect
function getImageRect(i){
    var imgs = document.getElementsByTagName("img");
    var rect;
    rect = imgs[i].getBoundingClientRect().left+"::";
    rect = rect+imgs[i].getBoundingClientRect().top+"::";
    rect = rect+imgs[i].width+"::";
    rect = rect+imgs[i].height+"::";
    return rect;
}

//get image url
function getAllImageUrl(){
    var imgs = document.getElementsByTagName("img");
    var urlArr = [];
    for(var i=0;i<imgs.length;i++){
        var src = imgs[i].src;
        urlArr.push(src);
    }
    return urlArr.toString();
}

//get image data
function getImageData(i){
    var imgs = document.getElementsByTagName("img");
    var img = imgs[i];
    var canvas = document.createElement("canvas");
    var context = canvas.getContext("2d");
    canvas.width = img.width;
    canvas.height = img.height;
    context.drawImage(img,0,0,img.width,img.height);
    return canvas.toDataURL("image/png");
}
