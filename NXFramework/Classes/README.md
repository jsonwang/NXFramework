NXLib
==========
- 所有类名使用NX前缀.
- NXCategory 中方法前加nx_ 前缀.

20161130
 NXExternals 中 不在包括其它第三方常用库, 以后会心POD 组件方式管理第三方库

 /*
  使用说明 XXXX 非常重要
  要导入
  1,libsqlite3.0.tbd FMDB使用
  2,libz.tbd  NSData+NXCategory gzip 使用

  方法1:
  Targets --> build Settings --> Other Linker Flags  添加 -lz  -lsqlite3
  方法2:
  Targets --> build phases --> link binary with libraries  加  libsqlite3.0.tbd  libz.tbd   
  */


NXBusiness 为基础业务组件
