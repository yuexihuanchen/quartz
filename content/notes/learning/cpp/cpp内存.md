
| 概念             | 关注的问题              |
| -------------- | ------------------ |
| Ownership（所有权） | 谁负责管理资源并最终释放它？     |
| Lifetime（生命周期） | 对象从什么时候存在，到什么时候销毁？ |
| Reference（引用）  | 我通过什么方式访问已有对象？     |
## 左值、右值
C++ 左值引用不拥有对象的内存，它只是给已经存在的对象提供了另一个访问入口。对象的所有权和生命周期不会因为创建引用而发生改变。
`const` 引用在绑定特定临时对象时存在生命周期延长规则，但这不意味着所有 `const` 引用都能延长对象生命周期。
引用相当于给一个有内存的对象换一条路径访问该对象内存，如果有const修饰，则引用不意味着对象本身不可变，而是不能通过这条引用访问路径修改它。
![](data:image/svg+xml;charset=utf-8,%3Csvg%20font-family%3D%22-apple-system-body%2C%20ui-sans-serif%2C%20-apple-system%2C%20system-ui%2C%20%26quot%3BSegoe%20UI%26quot%3B%2C%20Helvetica%2C%20%26quot%3BApple%20Color%20Emoji%26quot%3B%2C%20Arial%2C%20sans-serif%2C%20%26quot%3BSegoe%20UI%20Emoji%26quot%3B%2C%20%26quot%3BSegoe%20UI%20Symbol%26quot%3B%22%20font-weight%3D%22400%22%20data-d-component%3D%22svg%22%20fill%3D%22currentColor%22%20style%3D%22color%3Argb\(13%2C%2013%2C%2013\)%22%20viewBox%3D%220%200%20340%20216%22%20width%3D%22100%25%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20x%3D%22102%22%20y%3D%2212%22%20width%3D%22136%22%20height%3D%2247%22%20rx%3D%227%22%20fill%3D%22%23DCECFD%22%20stroke%3D%22%23477DB4%22%2F%3E%3Ctext%20x%3D%22170%22%20y%3D%2229%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20font-weight%3D%22bold%22%20fill%3D%22%23173C69%22%3Estd%3A%3Astring%20s%3C%2Ftext%3E%3Ctext%20x%3D%22170%22%20y%3D%2246%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20fill%3D%22%23173C69%22%3E%22Example%22%3C%2Ftext%3E%3Crect%20x%3D%228%22%20y%3D%22134%22%20width%3D%22148%22%20height%3D%2250%22%20rx%3D%227%22%20fill%3D%22%23DCF4E9%22%20stroke%3D%22%2329966C%22%2F%3E%3Ctext%20x%3D%2282%22%20y%3D%22154%22%20text-anchor%3D%22middle%22%20font-size%3D%2212%22%20font-weight%3D%22bold%22%20fill%3D%22%23176C50%22%3Estd%3A%3Astring%26amp%3B%20r1%3C%2Ftext%3E%3Ctext%20x%3D%2282%22%20y%3D%22172%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%23176C50%22%3E%E5%8F%AF%E4%BF%AE%E6%94%B9%E7%9A%84%E5%BC%95%E7%94%A8%3C%2Ftext%3E%3Crect%20x%3D%22184%22%20y%3D%22134%22%20width%3D%22148%22%20height%3D%2250%22%20rx%3D%227%22%20fill%3D%22%23F7E9D3%22%20stroke%3D%22%23B78740%22%2F%3E%3Ctext%20x%3D%22258%22%20y%3D%22154%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20font-weight%3D%22bold%22%20fill%3D%22%237D5421%22%3Econst%20std%3A%3Astring%26amp%3B%20r2%3C%2Ftext%3E%3Ctext%20x%3D%22258%22%20y%3D%22172%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22%237D5421%22%3E%E5%8F%AA%E8%AF%BB%E5%BC%95%E7%94%A8%3C%2Ftext%3E%3Cpath%20d%3D%22M82%20132%20L82%20102%20Q82%2091%2096%2082%20L151%2061%22%20fill%3D%22none%22%20stroke%3D%22%2329966C%22%20stroke-width%3D%222.5%22%20stroke-linecap%3D%22round%22%2F%3E%3Cpath%20d%3D%22M258%20132%20L258%20102%20Q258%2091%20244%2082%20L189%2061%22%20fill%3D%22none%22%20stroke%3D%22%23B78740%22%20stroke-width%3D%222.5%22%20stroke-linecap%3D%22round%22%2F%3E%3Cpath%20d%3D%22M151%2061%20L141%2065%20L148%2074%20Z%22%20fill%3D%22%2329966C%22%2F%3E%3Cpath%20d%3D%22M189%2061%20L199%2065%20L192%2074%20Z%22%20fill%3D%22%23B78740%22%2F%3E%3Ctext%20x%3D%22170%22%20y%3D%22201%22%20text-anchor%3D%22middle%22%20font-size%3D%2211%22%20fill%3D%22currentColor%22%3E%E4%B8%A4%E6%9D%A1%E5%BC%95%E7%94%A8%E5%85%B3%E7%B3%BB%EF%BC%8C%E6%8C%87%E5%90%91%E5%90%8C%E4%B8%80%E4%B8%AA%E5%AF%B9%E8%B1%A1%3C%2Ftext%3E%3C%2Fsvg%3E)


std::string& getString()
{
    std::string s = "Hello";
    return s;  // 错误：返回局部对象的引用
}

### 左值与右值
***值类别是表达式的性质，而不是对象的性质，每个表达式都属于三个基本类型中的一种：纯右值（prvalue）、亡值（xvalue）、左值（lvalue）。***

==🔵纯右值==符合下列之一的表达式：
	计算某个运输符的操作数的值（这种纯右值无结果对象）。
	初始化某个对象（这种除右值有一个结果对象）。
即要么是纯粹的字面量，要么是求值结果相当于字面量或匿名临时对象。如1+2，非引用返回的临时表达量、运算表达式产生的临时变量、原始字面量lambda表达式。
**字面量除了字符串字面量外 均为纯右值，而字符串字面量是一个左值，类型为const char数组。***
==🔵亡值==代表他的资源能够被重新使用的对象或位域的泛左值
 
==🔵左值==初步印象，有持久身份，表达式结束后依然存在的***持久对象***。故可以取地址&、可作为函数返回值、可绑定到左值引用 int&。
==🔵右值==初步印象，临时的无持久身份，表达式结束之后不在存在的***临时对象***。故生命周期结束后自动销毁，不可取地址、通常不可作为函数返回值（除非移动语义），可绑定到右值引用int&&。
一般来说，左值不可以绑定到要转换的表达式，字面常量或返回右值的表达式。右值引用则相反，不能绑到一个左值上，必须绑定到右值引用上，&&。右值引用只能绑定到一个将要销毁的对象上。
==>std::move(x), x 是左值，std::move(x)右值。
### 左值引用右值引用
要拿到一个亡值，就要用到右值引用：***T&&*** 其中T是类型，右值引用让这个临时变量的生名周期延长，只要变量还活着，那么亡值将继续存活。即可以绑定那写会被销毁的临时对象，右值引用允许我们对其资源进行移动操作而不是复制操作。
***std::move()*** 将左值参数无条件的转换为右值
	std::move()只是***类型转换***，把左值强制转换成右值引用表达式（T&&），它本身不搬移资源也不销毁任何东西。真正的移动发生在==🔵移动构造函数==、移动赋值运算符。
移动构造函数：专门用于将一个右值引用对象，移动到另一个对象的构造函数，通过资所有权从一个对象转移到另一个对象避免不必要的数据复制。
### 引用坍缩规则
模板函数中使用 `T&&` 不一定能进行右值引用，当传入左值时，此函数的引用将被推导为左值。 更准确的讲，**无论模板参数是什么类型的引用，当且仅当实参类型为右引用时，模板参数才能被推导为右引用类型**。***凡是折叠中出现左值引用，优先将其折叠为左值引用。***
```
typedef int&  lref;
typedef int&& rref;
int n;

lref&  r1 = n; // type of r1 is int&
lref&& r2 = n; // type of r2 is int&
rref&  r3 = n; // type of r3 is int&
rref&& r4 = 1; // type of r4 is int&&
```
### 完美转发
就是为了让我们在传递参数的时候， 保持原来的参数类型（左引用保持左引用，右引用保持右引用）。 为了解决这个问题，我们应该使用 `std::forward` 来进行参数的转发（传递）：
```
#include <iostream>
#include <utility>
void reference(int& v) {
    std::cout << "左值引用" << std::endl;
}
void reference(int&& v) {
    std::cout << "右值引用" << std::endl;
}
template <typename T>
void pass(T&& v) {
    std::cout << "              普通传参: ";
    reference(v);
    std::cout << "       std::move 传参: ";
    reference(std::move(v));
    std::cout << "    std::forward 传参: ";
    reference(std::forward<T>(v));
    std::cout << "static_cast<T&&> 传参: ";
    reference(static_cast<T&&>(v));
}
int main() {
    std::cout << "传递右值:" << std::endl;
    pass(1);

    std::cout << "传递左值:" << std::endl;
    int v = 1;
    pass(v);

    return 0;
}
```
输出结果为：
```
传递右值:
              普通传参: 左值引用
       std::move 传参: 右值引用
    std::forward 传参: 右值引用
static_cast<T&&> 传参: 右值引用
传递左值:
              普通传参: 左值引用
       std::move 传参: 右值引用
    std::forward 传参: 左值引用
static_cast<T&&> 传参: 左值引用
```
即无论传递参数是左值还是右值，普通传参都会将其视为左值进行转发；
而 ```std::move() ```总会接受一个左值，从而转发调用 ```reference(int&&)``` 输出右值引用；
std::forward没有造成任何多余拷贝，同时==完美转发==🟡了函数实参给了内部调用的其他函数。
***std::foward*** 和std::move一样，没有做任何事情，***std::move单纯的将左值转换为一个右值***，
***std::forward也是单纯的将参数进行一个类型准换***，从现象上看```std::forward<T>(v)和static_cast<T&&>(v)```是完全一样的。
当 `std::forward` 接受左值时，`_Tp` 被推导为左值，所以返回值为左值；而当其接受右值时， `_Tp` 被推导为 右值引用，则基于坍缩规则，返回值便成为了 `&& + &&` 的右值


