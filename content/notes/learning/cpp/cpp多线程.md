## 1、进程、线程
==进程==：资源分配的基本单位，拥有独立的虚拟地址空间。不同的进程默认不能直接访问对方内存，隔离性较好 但是创建和切换开销也大。
我们编写的代码只是存储在硬盘里的静态文件，通过编译后会生成二进制可执行文件，当运行这个可执行文件后，会装载道内存中，接着cpu会执行程序中的每条指令，这个运行中的程序就是***进程***。
==线程==：进程内的执行单元，操作系统调度的基本单位，同一进程内的线程共享堆、全局变量和打开的文件资源 但各自有独立的栈和寄存器上下文，共享数据方便。
==协程==：由语言运行时或协程库在用户态调度的执行单元，协程切换不需要内核，开销较小。**协程要依托线程执行，不会凭空增加cpu的并行能力**。

如果把整个比作一个外卖店，则***进程***相当于整家店，拥有自己的地址和空间资源。***线程***相当于店里的员工负责做菜、接单、打包等任务。***并发（concurrency）*** 表示一名员工在不同任务之间切换，或多个员工同时推进多个任务。***并行（parellelism）*** 多名员工同一时刻真正执行不同的任务。
==并发==：多个任务在**同一段时间内交替推进**，不要求在同一时刻执行。
==并行==：多个任务在**同一个时刻同时进行**，通常要多个cpu核心。

![[Pasted image 20261021085559.png]]

#### 1、==🟡std::thread==
```
#include <iostream>
#include <thread>

void work() {
    std::cout << "子线程正在工作\n";
}

int main() {
    std::thread t(work); // 当执行到这时，系统会尝试创建一个新线程，让他执行work()

    std::cout << "主线程正在工作\n";

    t.join();  // 可以理解为 主线程对新线程说，你先把自己的工作做完，我在这等你；你结束后，我再继续往下运行。 即等待线程执行结束

    return 0;
}


// 输出可能是： 
		子线程正在工作
		主线程正在工作
	也可能是：
		主线程正在工作
		子线程正在工作
	还有可能因多个线程同时输出而出现内容交错
```
main()主程序在执行的函数，work()希望让新线程执行的任务，t一个新创建的std::thread对象，用来管理新创建的线程

如果不加```t.join();``` 即
```
int main() {
    std::thread t(work);
    return 0;
}
```
这个程序不是简单地“主线程退出，子线程被自动回收”。
它的问题在于t离开作用域并析构时，若仍处于`joinable()`状态，`std::thread`的析构函数会调用`std::terminate()`，导致程序异常终止。
所以对于`std::thread`: **`join`等待线程结束**；**`detach()`:将线程与整个管理对象分离**。
若**两者都不调用**，线程对象仍可关联线程时析构，**导致`std::terminate()`**
同一个线程对象不能重复`join()`，可以用
```
if (t.joinable()) {
    t.join();
}
```
判断它是否仍关联一个可以等待的线程。**`joinable()` 不等于“线程还在运行”**。即使线程函数已经执行结束，在调用 `join()` 或 `detach()` 之前，它仍可能是 `joinable()` 的。
==`join()`== 相当于等待员工完成任务，再继续下一步。
==`detach()`==安排好任务后不再通过这个线程对象等待或管理员工。**存在危险，可能还使用你提供的数据，而这数据已经不存在了**。
**`sleep_for()`不是线程同步机制**

**线程传参需要==`std::ref()`==**
比如：
```
void add(int& x) { 
	x++; 
}

int main(){
	int num = 10;
	std::thread t(add, num);
	t.join();
}
```
这段代码不能通过标准 C++ 编译。
因为`std::thread`默认把传入的普通参数保存为经过类型退化处理的独立值，然后用于调用线程函数。尽管 `add()` 需要的是 `int&`，线程并不会因此自动保留外部 `num` 的引用关系

应该这样写：
```
int num = 10;
std::thread t(add, std::ref(num));

t.join();

std::cout << num;
```
`std::ref()` 到底做了什么？
简单理解：`std::ref(num)`生成一个 `std::reference_wrapper<int>` 对象。这个对象保存对 `num` 的引用关系，并在调用目标函数时提供相应的引用。
- |`std::thread t(work, num)`|默认按值保存参数|
- |`std::thread t(work, std::ref(num))`|让线程函数通过引用访问原变量|
- |`std::thread t(work, std::cref(num))`|通过常量引用访问原变量|
**引用传参解决的是“访问同一个对象”的问题，不意味着访问一定线程安全**

#### 2、线程管控
==线程所有权转移==，首先线程**不允许复制构造和复制赋值**，即不可以`std::thread t2 = t1;`;
但是**可以移动**即`std::thread t2 = std::move(t1);`.
那么`std::move`到底转移了什么
![[Pasted image 20261024223852.png]]
- 移动构造：可以从一个已有线程的对象转移所有权。
- 移动赋值：目标对象必须不再关联可汇合线程。
- 移动之后：源对象不再管理被转移的线程。
- 线程执行本身与线程管理对象是两个不同的概念。

 joining_thread：给线程配一个“善后管家”
**一句话总结：`joining_thread` = `std::thread` 的 RAII 包装，析构时自动 `join()`，让“忘记 join 导致程序崩溃”这类事故从语法上不可能发生。** 它是 `std::jthread`（C++20）的前身。
![[Pasted image 20261025093751.png]]

==容器存储==
|`emplace_back(work, i)`|可以|直接在容器内构造线程|
|`push_back(std::move(t))`|可以|将已有线程对象移动进去|
|`push_back(t)`|不可以|需要复制一个不可复制的线程对象|

==hardware_concurrency==这个函数返回一个提示值，表示当前硬件环境支持的并发线程数量，但是**它不是绝对的 CPU 物理核心数，也不保证就是最优线程数。**
因此，不能简单地认为“CPU 有 16 个逻辑处理器，就必须创建 16 个线程”。创建线程本身有开销，线程太多还可能增加调度和上下文切换成本。

#### 3、互斥与死锁
`std::mutex` 理解成一把只能由一个线程持有的锁。
```
#include <mutex>

std::mutex mtx;
int shared_data = 100;

void add() {
    mtx.lock();

    ++shared_data;

    mtx.unlock();
}
```
执行过程：
1. 线程调用 `mtx.lock()`。
2. 如果锁没有被其他线程持有，线程获得锁。
3. 如果锁已经被其他线程持有，当前线程需要等待。
4. 完成共享数据的修改后，调用 `mtx.unlock()`。
5. 其他等待线程才有机会获得锁。

这里有一个重要概念：临界区（Critical Section）
**临界区就是访问共享资源、需要受到同步保护的代码区域。**

存在问题：
```
mtx.lock();
// 操作共享数据
mtx.unlock();
```
这种写法存在一个问题：如果中间发生异常，或者函数提前 `return`，就可能没有执行 `unlock()`

解决办法就是你上一篇已经接触过的 RAII。
**使用 std::lock_guard**
```
void update() {
    std::lock_guard<std::mutex> lock(mtx);

    ++shared_data;
}
```
这里发生了什么？
- 创建 `lock` 时，自动对 `mtx` 加锁。
    
- 执行共享数据操作。
    
- 离开当前作用域时，`lock` 析构。
    
- 析构时自动释放锁。

==线程安全的数据结构==
设计一个线程安全栈 `threadsafe_stack1`。
它有三个主要操作：
```
push()
pop()
empty()
```
其中 `empty()` 大致如下：
```
bool empty() const {
    std::lock_guard<std::mutex> lock(m);
    return data.empty();
}
```
这个函数是线程安全的：检查栈是否为空时，其他线程不能同时进入同一把锁保护的临界区

假设栈里只有一个元素：
```
栈顶
 ┌─────┐
 │  10 │
 └─────┘
```
现在有两个线程：
```
// 线程 A
if (!safe_stack.empty()) {
    safe_stack.pop();
}

// 线程 B
if (!safe_stack.empty()) {
    safe_stack.pop();
}
```
你可能认为 `empty()` 已经加锁，所以没有问题。
实际上，问题出在 `empty()` 返回之后。
![[Pasted image 20261025113050.png]]
因此，你不能把：
```
if (!safe_stack.empty()) {
    safe_stack.pop();
}
```
当作一个整体的原子操作。
即使 `empty()` 和 `pop()` 各自内部都加了锁，两个函数之间仍然存在时间窗口。

==那么怎样设计真正安全的 pop()？==
最直接的思路是：
把 **“检查栈是否为空”和“弹出元素”放在同一次加锁操作中完成**。
例如：
```
T pop() {
    std::lock_guard<std::mutex> lock(m);

    if (data.empty()) {
        throw empty_stack();
    }

    T element = data.top();
    data.pop();

    return element;
}
```
这样，栈为空的检查和出栈操作就由同一把锁保护。

==如何避免死锁？==
方法一：**统一加锁顺序**
最直接的方法是规定：不管哪个线程，都必须先拿锁 1，再拿锁 2。
例如：
```
void safe_work() {
    std::lock_guard<std::mutex> lock1(t_lock1);
    std::lock_guard<std::mutex> lock2(t_lock2);

    // 同时操作两份受保护的数据
}
```
只要所有需要同时获取两把锁的代码都遵循相同顺序，就能避免这种由锁顺序相反引起的循环等待

方法二：**使用 std::lock**
C++ 提供了 `std::lock()`，可以同时获取多个互斥锁，并采用避免死锁的加锁算法。
例如：
```
std::lock(t_lock1, t_lock2);
```
执行后，这两把锁都已经被当前线程锁定。`std::lock()` 本身不会在作用域结束时自动解锁，因此仍然需要管理锁的释放。
原文使用的是 `std::adopt_lock`：
```
std::lock(t_lock1, t_lock2);

std::lock_guard<std::mutex> guard1(
    t_lock1, std::adopt_lock
);

std::lock_guard<std::mutex> guard2(
    t_lock2, std::adopt_lock
);
```
这里的 `std::adopt_lock` 可以理解为：**这把锁已经被当前线程获取了，请让这个管理对象接管它的释放责任，而不是再次加锁。**
随后，两个 `lock_guard` 在离开作用域时分别释放对应的锁。

方法三：**C++17 的 std::scoped_lock**
如果你使用 C++17 或更新标准，通常可以写得更简洁。
```
#include <mutex>

void safe_work() {
    std::scoped_lock lock(t_lock1, t_lock2);

    // 同时操作两份受保护的数据
}
```
它会安全地获取多个锁，并在对象析构时自动释放。

层级锁 `hierarchical_mutex` 是什么？
层级锁解决的是： **怎样强制所有线程遵守加锁顺序，而不是只靠程序员自觉？**
```cpp
hmtx1.lock();  // 当前线程持有 1000 层锁
hmtx2.lock();  // 再获取 500 层锁，允许

hmtx2.unlock();
hmtx1.unlock();
```
释放顺序通常与获取顺序相反，类似栈：
先获得的锁，后释放；
后获得的锁，先释放。



## 2、进程间的通信
### 1 管道
所谓管道就是**内核里的一串缓存**
| 匿名管道 单向传输
命名管道（FIFO）
![[Pasted image 20261021092315.png]]
如何进行进程间的通信？
利用```fork``` 创建子进程,子进程会复制父进程的文件描述符
![[Pasted image 20261021092946.png]]
对于**匿名管道 通信范围是存在父子关系的进程**，因为管道没有实体，只能fork来复制父进程fd文件描述符来通信。
对于**命名管道 可以在不想关的进程之间通信**，提前创建了一个类型为管道的设备文件，在进程中使用这个文件就可以互相通信。

### 2 消息队列
保存在内核中的消息链表，适合频繁的交换数据，但是不足是通信不及时、附件大小有限制，同时通信过程中存在用户态与内核态之间的数据拷贝开销。

### 3 共享内存
拿出一块虚拟地址空间，映射到相同的物理内存中

### 4 信号量
为了防止多进程竞争共享资源
**信号量是一个整形计数器，用于实现进程间的互斥与同步，不用于缓存进程间通信的数据**

### 5 信号
异常情况下的工作模式
异步通信机制

### 6 socket
以上都是同一台主机间的进程通信，想要***跨网络与不同主机上的进程间通信***就要用socket，
socket不仅可以跨网络 也可以在同主机上通信
![[Pasted image 20261021101054.png]]



每个进程的用户空间都是独立的不能相互访问，这就需要借助内核空间实现进程间的通信，因为每个进程都共享同一个内核空间

## 3、多线程冲突
==互斥== 保证一个线程在临界区执行时，其他线程被阻止进入临界区，即这段代码在执行过程中，最多只能出现一个线程。
**互斥解决了并发进程/线程的临界区使用问题**
==同步== 在并发进程/线程在一些关键的可能需要**互相等待与互通消息**，这种相互制约的等待与互通信息称为线程/进程同步

## 4、锁
### （1）、基本锁介绍：
==🟡 1、互斥锁==：加锁失败后，线程会**释放cpu**，给其他线程。
	互斥锁是一种 **独占锁**  如当线程A加锁成功后，此时互斥锁被线程A独占，只要线程A没有释放手中的锁，线程B加锁就会失败，就会释放CPU给其他线程，线程B释放了CPU,线程B加锁的代码就会被阻塞。
	对于互斥锁加锁失败而造成的阻塞态，是由操作系统内核实现的。即互斥锁加锁失败，会从***用户态进入到内核态***，让内核切换线程，会有**两次线程上下文切换的成本**。==> 线程的上下文切换的是什么：当两个线程属于同一个进程，因为虚拟内存是共享的，所以切换时虚拟内存这些资源保持不动，只需要切换线程的私有数据、寄存器等不共享的数据。
	==🔴如果你确定被锁住的代码执行时间很短，就不应该用互斥锁，而应该用自旋锁。==
	
==🟡2、自旋锁(spin lock)==  即当获取不到锁时，线程就会一直while循环，不做任何事，这种 ***忙等待锁*** 被称为***自旋锁***。
	通过cpu提供的CAS函数（Compare And Swap），在用户态完成加锁和解锁过程，不会主动产生线程的上下文切换，所以相比互斥锁来说，会快一些 开销也会小。
	自旋锁是一种比较简单的锁，一直自旋，利用CPU周期，直到锁可用。
	
**当加锁失败时，==🟢互斥锁用线程切换==来应对，==🟡自旋锁则用忙等待==来应对。**

==3、读写锁==
适用于能明确区分读操作和写操作的场景
工作原理
	当**写锁**没有被线程持有，多个线程能并发的持有**读锁**，这大大提高了共享资源的访问效率，因为读锁是用于读取共享资源，所以多个线程同时持有读锁不会破坏共享资源的数据
	但一旦**写锁**被线程持有后，读线程的获取读锁的操作会被阻塞，而且其他线程获取写锁的操作也会被阻塞
所以 **写锁是独占锁，任何时刻只能有一个线程持有写锁**，类似互斥锁和自旋锁；而**读锁是共享锁，因为可以被多个线程同时持有**。
读写锁适用于**读多写少**的场景。
公平读写锁的比较简单的一种方式是：用队列把获取锁的线程排队，不管是写线程还是读线程都按照先进先出的原则加锁，这样读线程仍可并发，也不会出行饥饿现象。

4、==乐观锁悲观锁==
前面的***互斥锁、自旋锁、读写锁 都属于悲观锁***
==🟢悲观锁==认为**多线程同时修改共享资源的概率较高，于是很容易出现冲突，所以访问共享资源前，先要上锁**。
反之，若多线程同时修改共享资源的概率比较低，就采用乐观锁。
==🟢乐观锁==假定冲突的概率很低，***先修改完共享资源，再验证这段时间内有没有发生冲突***，若没有其他线程在修改资源，那么操作完成，如果发现其他线程已经修改过这个资源，就放弃本次操作。
	乐观锁全程没有加锁，所以也叫无锁编程
### （2）、unique_lock、共享锁、递归锁
#### unique_lock

| 类型                     | 角色      | 主要用途           |
| ---------------------- | ------- | -------------- |
| `std::mutex`           | 普通互斥量   | 保证同一时间只有一个线程持有 |
| `std::lock_guard`      | 锁管理器    | 作用域结束自动解锁      |
| `std::unique_lock`     | 灵活的锁管理器 | 支持手动释放、重新获取等   |
| `std::shared_mutex`    | 读写互斥量   | 允许共享读取、独占写入    |
| `std::shared_lock`     | 共享锁管理器  | 获取和释放共享所有权     |
| `std::recursive_mutex` | 可重入互斥量  | 允许同一个线程多次锁定    |

==unique_lock 和 lock_guard 有什么区别？==
```
std::mutex mtx;
int count = 0;

void work() {
    std::lock_guard<std::mutex> lock(mtx);
    ++count;
}
```

当 `lock` 创建时获取锁，离开作用域时自动释放锁。
如果换成：

```
void work() {
    std::unique_lock<std::mutex> lock(mtx);
    ++count;
}
```
基本效果一样。
那么为什么还要设计 `unique_lock`？

因为**它允许你在对象生命周期内灵活管理锁的持有状态。包括 `lock()`、`unlock()`、`owns_lock()`延迟加锁以及移动管理权等操作。**
最直观的区别是：
```
std::unique_lock<std::mutex> lock(mtx);

++count;       // 正在持有锁

lock.unlock(); // 主动释放锁

// 这里可以执行不需要锁的操作

lock.lock();   // 再次获取锁

++count;
```
而 `lock_guard` 没有提供这样的手动 `unlock()`、`lock()` 接口。

==为什么要提前解锁？==
这是工程中非常重要的一个问题。
假设一个函数需要：
1. 修改共享数据。
    
2. 执行一个耗时 2 秒的计算。
    
3. 再次修改共享数据。
![[Pasted image 20261025202026.png]]

==owns_lock() 到底判断什么？==
**当前这个 `unique_lock` 对象是否持有其关联互斥量的所有权。** 它不是全局检测某个互斥量是否被任意线程锁住。

==defer_lock：延迟加锁==
```
std::unique_lock<std::mutex> lock(mtx, std::defer_lock);
```
可以理解为：创建一个负责管理 `mtx` 的锁对象，但先不要获取锁。

==adopt_lock：接管已经获得的锁==
```
std::mutex mtx;

mtx.lock();

std::unique_lock<std::mutex> lock(
    mtx, std::adopt_lock
);
```
这里的 `adopt_lock` 是在告诉 `unique_lock`：

**当前线程已经持有这把锁，你直接接管后续解锁责任，不需要再调用一次 `lock()`。**

这里特别容易犯错：
```
std::unique_lock<std::mutex> lock(
    mtx, std::adopt_lock
);
```

**不能在当前线程尚未持有锁时这样使用**，否则违反前置条件，行为未定义。

另一个常见错误：
```
mtx.lock();

std::unique_lock<std::mutex> lock(
    mtx, std::adopt_lock
);

mtx.unlock();  // 错误的所有权管理方式
```
此时 `unique_lock` 仍认为自己持有锁，以后析构时还会尝试解锁。
所以，**采用 `adopt_lock` 后应让管理对象负责释放。**
#### 共享锁
==为什么多个线程可以同时读取？==
假设你在做一个 DNS 查询系统，内部保存：
```
www.baidu.com  ->  IP 地址 A
www.qq.com     ->  IP 地址 B
www.example.com -> IP 地址 C
```

现在有三个线程：
- 线程 A：查询 `www.baidu.com`。
    
- 线程 B：查询 `www.qq.com`。
    
- 线程 C：修改 `www.example.com` 的 IP。

问题来了：
线程 A 和 B 都只是读取数据，为什么不允许它们同时读取？
如果使用普通 `std::mutex`：

```
std::lock_guard<std::mutex> lock(mtx);
```

那么线程 A 持有锁时，线程 B 即使只读数据，也必须等待。
这种方式正确，但在读取远多于写入的场景中，可能限制并发能力。
于是我们引入读写锁。
![[Pasted image 20261025205418.png]]
**读读可以并发，读写互斥，写写互斥。**

==shared_mutex 和 shared_lock 如何配合？==
```

#include <iostream>
#include <thread>
#include <shared_mutex>
#include <mutex>
#include <map>
#include <string>

class DNSCache {
private:
    std::map<std::string, std::string> data;

    mutable std::shared_mutex mtx;

public:
    // 查询：共享锁
    std::string query(const std::string& name) const {
        std::shared_lock<std::shared_mutex> lock(mtx);

        auto it = data.find(name);

        if (it != data.end()) {
            return it->second;
        }

        return "";
    }

    // 修改：独占锁
    void update(
        const std::string& name,
        const std::string& ip
    ) {
        std::unique_lock<std::shared_mutex> lock(mtx);

        data[name] = ip;
    }
};

int main() {
    DNSCache cache;

    cache.update("example.com", "1.1.1.1");

    std::thread t1([&]() {
        std::cout << "Reader 1: "
                  << cache.query("example.com")
                  << "\n";
    });

    std::thread t2([&]() {
        std::cout << "Reader 2: "
                  << cache.query("example.com")
                  << "\n";
    });

    t1.join();
    t2.join();

    return 0;
}
```

读取数据：
```
std::shared_lock<std::shared_mutex> lock(mtx);
```

修改数据：
```
std::unique_lock<std::shared_mutex> lock(mtx);
```

注意！

共享锁和独占锁操作的是同一个 `shared_mutex`，区别在于如何获取它。

- `shared_lock`：以共享模式获取。
    
- `unique_lock`：以独占模式获取。

实际上，写入操作也可以这样实现：
```
std::lock_guard<std::shared_mutex> lock(mtx);
```
同样是独占模式。

==为什么成员变量前面有 mutable？==
```
mutable std::shared_mutex mtx;
```

因为我们的查询函数是：
```
std::string query(...) const
```

`const` 成员函数不应该修改对象在业务层面可观察的数据状态。

但是查询过程仍然需要对互斥量加锁，而加锁会改变互斥量的内部状态。

`mutable` 允许我们在 `const` 成员函数中管理这个同步对象。

你可以理解为：

> 读取函数没有修改 DNS 记录，但它需要改变锁的状态来保证读取安全。


#### 递归锁
==recursive_mutex——为什么能够重复加锁？==
```
std::mutex mtx;

void funcB() {
    std::lock_guard<std::mutex> lock(mtx);
    std::cout << "B\n";
}

void funcA() {
    std::lock_guard<std::mutex> lock(mtx);
    funcB();
}
```

调用：
```
funcA();
```
==会发生什么？==

执行顺序：
1. `funcA()` 获得 `mtx`。
    
2. `funcA()` 调用 `funcB()`。
    
3. `funcB()` 再次尝试获取同一个 `mtx`。
    
4. 但是当前线程已经持有这把锁。
    
对于普通 `std::mutex`，同一线程重复调用 `lock()` 违反标准要求，属于未定义行为。在常见实现中可能表现为卡死，但不能把“必然卡死”当作标准保证

==如何解决？==
同一个线程就可以重复获取这把锁。
你可以理解为互斥量内部需要记录当前线程重复锁定的次数。
例如：

|操作|持锁层数|
|---|---|
|第一次 `lock()`|1|
|第二次 `lock()`|2|
|第一次 `unlock()`|1|
|第二次 `unlock()`|0|

当对应次数的解锁全部完成后，这把锁才真正释放给其他线程
**`recursive_mutex` 只允许同一个线程重复锁定，不允许不同线程同时独占这把锁**




