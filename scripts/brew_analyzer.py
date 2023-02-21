# ref: https://github.com/skytoup/brew_deps
import os
from typing import Dict

PKG_SPLIT_CHAR = ': '
DEP_SPLIT_CHAR = ' '


class BrewPackage:
    def __init__(self, name: str):
        self.name = name
        self.deps = []
        self.has_dep = False

    @classmethod
    def _deps_str(cls, package, level: int = 0, need_deep: bool = False):
        ts = '\t' * (level + 1)
        s = ''
        for p in package.deps:
            s += '{}- {}\n'.format(ts, p.name)
            if need_deep and p.deps:
                s += cls._deps_str(p, level + 1)
        return s

    def __repr__(self) -> str:
        return '{}:\n{}'.format(self.name, BrewPackage._deps_str(self))
        # return '{}: {}'.format(self.name, self.deps)


def get_cache_package(package_name: str) -> BrewPackage:
    pkg = all_package_dict.get(package_name)
    if not pkg:
        pkg = BrewPackage(package_name)
        all_package_dict[package_name] = pkg
    return pkg


all_package_dict: Dict[str, BrewPackage] = {}

with os.popen('brew deps --installed') as popen:
    dep_lines = popen.read().split('\n')

    for idx, line in enumerate(dep_lines):

        if not line:
            continue

        result = line.split(PKG_SPLIT_CHAR)
        pkg_name = result[0]
        dep_names = result[1].split(DEP_SPLIT_CHAR) if len(
            result) == 2 and result[1] else None

        package = get_cache_package(pkg_name)

        if not dep_names:
            continue
        for dep_name in dep_names:
            dep_package = get_cache_package(dep_name)
            dep_package.has_dep = True
            package.deps.append(dep_package)

    print('All package and deps')
    print('--------------------')
    for package in all_package_dict.values():
        print(package)
    print('\n')

    # 这里print出来的包, 都没有被依赖, 看看那个不认识或不想要都可以卸载掉, 卸载完一遍后, 需要再次运行该程序分析
    # 如此循环, 直到没有找到需要卸载的包, 这样就清理干净了
    print('Not dependent packages')
    print('----------------------')
    not_dep_package = [p for p in all_package_dict.values() if not p.has_dep]
    for p in not_dep_package:
        print(p.name)
