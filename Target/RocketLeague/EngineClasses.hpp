#pragma once

#include <set>
#include <string>
#include <windows.h>
#include "../AllPointsBulletin/EngineClasses.hpp"

// GObjects: [+0x23] E8 [....] EB 82
//   GNames: [+0x2c] E8 [....] 48 83 CF FF 45 85 FF

template<class T>
struct TArray
{
    TArray()
    {
        Data = nullptr;
        Count = Max = 0;
    }

    size_t Num() const
    {
        return Num;
    }

    T& operator[](size_t i)
    {
        return Data[i];
    };

    const T& operator[](size_t i) const
    {
        return Data[i];
    };

    bool IsValidIndex(size_t i) const
    {
        return i < Num();
    }

private:
    T* Data;
    int32_t Num;
    int32_t Max;
};

struct FQWord
{
    int32_t A;
    int32_t B;
};

struct FName
{
    int32_t Index;
    int32_t Number;
};

class FNameEntry
{
public:
    char    pad_0000[8];
    int32_t Index;
    char    pad_000C[12];
    wchar_t Name[1024];
};

class UObject
{
public:
    void* VTableObject;
    char     pad_0008[0x30];
    int32_t  ObjectInternalInteger;
    int32_t  NetIndex;
    UObject* Outer;
    FName    Name;
    UObject* Inner;
    UObject* ObjectArchetype;
};

class UField : public UObject
{
public:
    UField* Next;
    char    pad_0008[0x8];
};

class UEnum : public UField
{
public:
    TArray<FName> Names;
};

class UConst : public UField
{
public:
    FString Value;
};

class UStruct : public UField
{
public:
    char    pad_0000[0x10];
    UField* SuperField;
    UField* Children;
    int32_t PropertySize;
    char    pad_0094[0x9c];
};

class UScriptStruct : public UStruct
{
public:
    char pad_0000[0x28];
};

class UFunction : public UStruct
{
public:
    int32_t FunctionFlags;
    char    pad_0134[0x8];
    FName   FriendlyName;
    int16_t NumParams;
    int16_t ParamSize;
    int32_t ReturnValueOffset;
    char    pad_014C[0x8];
    void* Function;
};

class UState : public UStruct
{
public:
    char pad_0000[0x60];
};

class UClass : public UState
{
public:
    char pad_0000[0x228];
};

class UProperty : public UField
{
public:
    int32_t ArrayDim;
    int32_t ElementSize;
    FQWord  PropertyFlags;
    char    pad_0080[0x10];
    int32_t PropertySize;
    char    pad_0094[0x4];
    int32_t Offset;
    char    pad_009C[0x2c];
};

class UByteProperty : public UProperty
{
public:
    UEnum* Enum;
};

class UBoolProperty : public UProperty
{
public:
    int64_t BitMask;
};

class UObjectProperty : public UProperty
{
public:
    UClass* PropertyClass;
    char    pad_00D0[0x8];
};

class UClassProperty : public UObjectProperty
{
public:
    UClass* MetaClass;
    char    pad_00D0[0x10];
};

class UInterfaceProperty : public UProperty
{
public:
    UClass* InterfaceClass;
};

class UStructProperty : public UProperty
{
public:
    UStruct* Struct;
};

class UArrayProperty : public UProperty
{
public:
    UProperty* Inner;
};

class UMapProperty : public UProperty
{
public:
    UProperty* KeyProp;
    UProperty* ValueProp;
};