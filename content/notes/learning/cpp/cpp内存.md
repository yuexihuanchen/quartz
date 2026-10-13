
| 概念             | 关注的问题              |
| -------------- | ------------------ |
| Ownership（所有权） | 谁负责管理资源并最终释放它？     |
| Lifetime（生命周期） | 对象从什么时候存在，到什么时候销毁？ |
| Reference（引用）  | 我通过什么方式访问已有对象？     |
## 引用、左值、右值
C++ 左值引用不拥有对象的内存，它只是给已经存在的对象提供了另一个访问入口。对象的所有权和生命周期不会因为创建引用而发生改变。
`const` 引用在绑定特定临时对象时存在生命周期延长规则，但这不意味着所有 `const` 引用都能延长对象生命周期。
引用相当于给一个有内存的对象换一条路径访问该对象内存，如果有const修饰，则引用不意味着对象本身不可变，而是不能通过这条引用访问路径修改它。
![](data:image/svg+xml;charset=utf-8,%3Csvg%20font-family%3D%22-apple-system-body%2C%20ui-sans-serif%2C%20-apple-system%2C%20system-ui%2C%20%26quot%3BSegoe%20UI%26quot%3B%2C%20Helvetica%2C%20%26quot%3BApple%20Color%20Emoji%26quot%3B%2C%20Arial%2C%20sans-serif%2C%20%26quot%3BSegoe%20UI%20Emoji%26quot%3B%2C%20%26quot%3BSegoe%20UI%20Symbol%26quot%3B%22%20font-weight%3D%22400%22%20data-d-component%3D%22svg%22%20fill%3D%22currentColor%22%20style%3D%22color%3Argb\(13%2C%2013%2C%2013\)%22%20viewBox%3D%220%200%20340%20216%22%20width%3D%22100%25%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20x%3D%22102%22%20y%3D%2212%22%20width%3D%22136%22%20height%3D%2247%22%20rx%3D%227%22%20fill%3D%22%23DCECFD%22%20stroke%3D%22%23477DB4%22%2F%3E%3Ctext%20x%3D%22170%22%20y%3D%2229%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20font-weight%3D%22bold%22%20fill%3D%22%23173C69%22%3Estd%3A%3Astring%20s%3C%2Ftext%3E%3Ctext%20x%3D%22170%22%20y%3D%2246%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20fill%3D%22%23173C69%22%3E%22Example%22%3C%2Ftext%3E%3Crect%20x%3D%228%22%20y%3D%22134%22%20width%3D%22148%22%20height%3D%2250%22%20rx%3D%227%22%20fill%3D%22%23DCF4E9%22%20stroke%3D%22%2329966C%22%2F%3E%3Ctext%20x%3D%2282%22%20y%3D%22154%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20font-weight%3D%22bold%22%20fill%3D%22%23176C50%22%3Estd%3A%3Astring%26amp%3B%20r1%3C%2Ftext%3E%3Ctext%20x%3D%2282%22%20y%3D%22172%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%23176C50%22%3E%E5%8F%AF%E4%BF%AE%E6%94%B9%E7%9A%84%E5%BC%95%E7%94%A8%3C%2Ftext%3E%3Crect%20x%3D%22184%22%20y%3D%22134%22%20width%3D%22148%22%20height%3D%2250%22%20rx%3D%227%22%20fill%3D%22%23F7E9D3%22%20stroke%3D%22%23B78740%22%2F%3E%3Ctext%20x%3D%22258%22%20y%3D%22154%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20font-weight%3D%22bold%22%20fill%3D%22%237D5421%22%3Econst%20std%3A%3Astring%26amp%3B%20r2%3C%2Ftext%3E%3Ctext%20x%3D%22258%22%20y%3D%22172%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%237D5421%22%3E%E5%8F%AA%E8%AF%BB%E5%BC%95%E7%94%A8%3C%2Ftext%3E%3Cpath%20d%3D%22M82%20132%20L82%20102%20Q82%2091%2096%2082%20L151%2061%22%20fill%3D%22none%22%20stroke%3D%22%2329966C%22%20stroke-width%3D%222.5%22%20stroke-linecap%3D%22round%22%2F%3E%3Cpath%20d%3D%22M258%20132%20L258%20102%20Q258%2091%20244%2082%20L189%2061%22%20fill%3D%22none%22%20stroke%3D%22%23B78740%22%20stroke-width%3D%222.5%22%20stroke-linecap%3D%22round%22%2F%3E%3Cpath%20d%3D%22M151%2061%20L141%2065%20L148%2074%20Z%22%20fill%3D%22%2329966C%22%2F%3E%3Cpath%20d%3D%22M189%2061%20L199%2065%20L192%2074%20Z%22%20fill%3D%22%23B78740%22%2F%3E%3Ctext%20x%3D%22170%22%20y%3D%22201%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22currentColor%22%3E%E4%B8%A4%E6%9D%A1%E5%BC%95%E7%94%A8%E5%85%B3%E7%B3%BB%EF%BC%8C%E6%8C%87%E5%90%91%E5%90%8C%E4%B8%80%E4%B8%AA%E5%AF%B9%E8%B1%A1%3C%2Ftext%3E%3C%2Fsvg%3E)


std::string& getString()
{
    std::string s = "Hello";
    return s;  // 错误：返回局部对象的引用
}

### 引用和指针
指针是一种独立的对象，用来保存另一个对象的地址；引用则是一种语言层面的别名关系，用来表示对已有对象的直接访问。
```
std::string s = "Hello";
std::string& r = s;
std::string* p = &s;
```
假设 `s` 的地址是 `0x1000`。

概念内存模型

![](data:image/svg+xml;charset=utf-8,%3Csvg%20font-family%3D%22-apple-system-body%2C%20ui-sans-serif%2C%20-apple-system%2C%20system-ui%2C%20%26quot%3BSegoe%20UI%26quot%3B%2C%20Helvetica%2C%20%26quot%3BApple%20Color%20Emoji%26quot%3B%2C%20Arial%2C%20sans-serif%2C%20%26quot%3BSegoe%20UI%20Emoji%26quot%3B%2C%20%26quot%3BSegoe%20UI%20Symbol%26quot%3B%22%20font-weight%3D%22400%22%20data-d-component%3D%22svg%22%20fill%3D%22currentColor%22%20style%3D%22color%3Argb\(13%2C%2013%2C%2013\)%22%20viewBox%3D%220%200%20344%20287%22%20width%3D%22100%25%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20x%3D%2295%22%20y%3D%2212%22%20width%3D%22154%22%20height%3D%2254%22%20rx%3D%228%22%20fill%3D%22%23DCECFD%22%20stroke%3D%22%234D83BC%22%20stroke-width%3D%221.5%22%2F%3E%3Ctext%20x%3D%22172%22%20y%3D%2231%22%20text-anchor%3D%22middle%22%20font-size%3D%2213%22%20font-weight%3D%22bold%22%20fill%3D%22%23224D7E%22%3Estd%3A%3Astring%20s%3C%2Ftext%3E%3Ctext%20x%3D%22172%22%20y%3D%2249%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20fill%3D%22%23224D7E%22%3E%E5%9C%B0%E5%9D%80%EF%BC%9A0x1000%3C%2Ftext%3E%3Crect%20x%3D%2210%22%20y%3D%22174%22%20width%3D%22146%22%20height%3D%2265%22%20rx%3D%228%22%20fill%3D%22%23DAF2E7%22%20stroke%3D%22%2342A078%22%20stroke-width%3D%221.5%22%2F%3E%3Ctext%20x%3D%2283%22%20y%3D%22194%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20font-weight%3D%22bold%22%20fill%3D%22%2318684C%22%3Estd%3A%3Astring%26amp%3B%20r%3C%2Ftext%3E%3Ctext%20x%3D%2283%22%20y%3D%22213%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%2318684C%22%3E%E5%88%AB%E5%90%8D%E5%85%B3%E7%B3%BB%3C%2Ftext%3E%3Ctext%20x%3D%2283%22%20y%3D%22227%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%2318684C%22%3E%E6%B2%A1%E6%9C%89%E7%8B%AC%E7%AB%8B%E6%8C%87%E9%92%88%E5%80%BC%3C%2Ftext%3E%3Crect%20x%3D%22188%22%20y%3D%22174%22%20width%3D%22146%22%20height%3D%2265%22%20rx%3D%228%22%20fill%3D%22%23F8E8D4%22%20stroke%3D%22%23C29151%22%20stroke-width%3D%221.5%22%2F%3E%3Ctext%20x%3D%22261%22%20y%3D%22194%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20font-weight%3D%22bold%22%20fill%3D%22%2383531F%22%3Estd%3A%3Astring*%20p%3C%2Ftext%3E%3Ctext%20x%3D%22261%22%20y%3D%22213%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%2383531F%22%3E%E5%AD%98%E5%82%A8%E6%8C%87%E9%92%88%E5%80%BC%3C%2Ftext%3E%3Ctext%20x%3D%22261%22%20y%3D%22227%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%2383531F%22%3E0x1000%3C%2Ftext%3E%3Cpath%20d%3D%22M82%20170%20L82%20115%20Q82%2098%2098%2086%20L149%2067%22%20stroke%3D%22%2342A078%22%20stroke-width%3D%222.5%22%20stroke-linecap%3D%22round%22%20fill%3D%22none%22%2F%3E%3Cpath%20d%3D%22M149%2067%20L139%2069%20L146%2078%20Z%22%20fill%3D%22%2342A078%22%2F%3E%3Cpath%20d%3D%22M261%20170%20L261%20115%20Q261%2098%20245%2086%20L194%2067%22%20stroke%3D%22%23C29151%22%20stroke-width%3D%222.5%22%20stroke-linecap%3D%22round%22%20fill%3D%22none%22%2F%3E%3Cpath%20d%3D%22M194%2067%20L204%2069%20L197%2078%20Z%22%20fill%3D%22%23C29151%22%2F%3E%3Ctext%20x%3D%22172%22%20y%3D%22264%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22currentColor%22%3E%E4%B8%A4%E8%80%85%E9%83%BD%E8%AE%BF%E9%97%AE%20s%EF%BC%8C%E4%BD%86%E8%AF%AD%E8%A8%80%E8%AF%AD%E4%B9%89%E4%B8%8D%E5%90%8C%3C%2Ftext%3E%3Ctext%20x%3D%22172%22%20y%3D%22280%22%20text-anchor%3D%22middle%22%20font-size%3D%2210%22%20fill%3D%22%23888888%22%3E%E5%BC%95%E7%94%A8%E7%9A%84%E5%BA%95%E5%B1%82%E5%AE%9E%E7%8E%B0%E7%94%B1%E7%BC%96%E8%AF%91%E5%99%A8%E5%86%B3%E5%AE%9A%3C%2Ftext%3E%3C%2Fsvg%3E)

### 悬空指针（Dangling Pointer）
```
std::string* p;

{
    std::string s = "Hello";
    p = &s;
}

// s 的生命周期已经结束

std::cout << *p; // 未定义行为
```
这里 `p` 仍然是一个存在的指针对象，但是它保存的地址不再对应一个存活的 `std::string` 对象。

引用也可能悬空：
```
std::string& getString()
{
    std::string s = "Hello";
    return s;
}
```
函数返回后 `s` 已经销毁，返回的引用不再有效。

**一个对象的访问关系可以仍然存在，但被访问对象的生命周期可能已经结束。**
有一个特殊情况值得记住：
```
const std::string& r = std::string("Hello");
```
这里临时 `std::string` 对象的生命周期会延长到局部引用 `r` 的生命周期结束。
但这属于 C++ 规定的特定临时对象生命周期延长规则，不代表引用普遍具有延长对象生命周期的能力。
