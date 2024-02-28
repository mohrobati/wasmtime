use anyhow::Result;
use wasmtime::component::{Component, Linker, ResourceType};
use wasmtime::{Engine, Store};

#[test]
fn old_import_importing_new_item() -> Result<()> {
    let engine = Engine::default();
    let mut linker = Linker::<()>::new(&engine);

    let ty = ResourceType::host::<u32>();
    linker.root().resource("a:b/c@1.0.1", ty, |_, _| Ok(()))?;

    let component = Component::new(
        &engine,
        r#"(component
            (import "a:b/c@1.0.0" (type $t (sub resource)))
            (export "a" (type $t))
        )"#,
    )?;
    let mut store = Store::new(&engine, ());
    let i = linker.instantiate(&mut store, &component)?;

    assert_eq!(i.get_resource(&mut store, "a"), Some(ty));

    Ok(())
}

#[test]
fn new_import_importing_old_item() -> Result<()> {
    let engine = Engine::default();
    let mut linker = Linker::<()>::new(&engine);

    let ty = ResourceType::host::<u32>();
    linker.root().resource("a:b/c@1.0.0", ty, |_, _| Ok(()))?;

    let component = Component::new(
        &engine,
        r#"(component
            (import "a:b/c@1.0.1" (type $t (sub resource)))
            (export "a" (type $t))
        )"#,
    )?;
    let mut store = Store::new(&engine, ());
    let i = linker.instantiate(&mut store, &component)?;

    assert_eq!(i.get_resource(&mut store, "a"), Some(ty));

    Ok(())
}

#[test]
fn import_both_old_and_new() -> Result<()> {
    let engine = Engine::default();
    let mut linker = Linker::<()>::new(&engine);

    let t1 = ResourceType::host::<u32>();
    let t2 = ResourceType::host::<i32>();
    linker.root().resource("a:b/c@1.0.0", t1, |_, _| Ok(()))?;
    linker.root().resource("a:b/c@1.0.1", t2, |_, _| Ok(()))?;

    let component = Component::new(
        &engine,
        r#"(component
            (import "a:b/c@1.0.0" (type $t1 (sub resource)))
            (import "a:b/c@1.0.1" (type $t2 (sub resource)))
            (export "t1" (type $t1))
            (export "t2" (type $t2))
        )"#,
    )?;
    let mut store = Store::new(&engine, ());
    let i = linker.instantiate(&mut store, &component)?;

    assert_eq!(i.get_resource(&mut store, "t1"), Some(t1));
    assert_eq!(i.get_resource(&mut store, "t2"), Some(t2));

    Ok(())
}

#[test]
fn missing_import_selects_max() -> Result<()> {
    let engine = Engine::default();
    let mut linker = Linker::<()>::new(&engine);

    let t1 = ResourceType::host::<u32>();
    let t2 = ResourceType::host::<i32>();
    linker.root().resource("a:b/c@1.0.1", t1, |_, _| Ok(()))?;
    linker.root().resource("a:b/c@1.0.2", t2, |_, _| Ok(()))?;

    let component = Component::new(
        &engine,
        r#"(component
            (import "a:b/c@1.0.0" (type $t1 (sub resource)))
            (import "a:b/c@1.0.3" (type $t2 (sub resource)))
            (export "t1" (type $t1))
            (export "t2" (type $t2))
        )"#,
    )?;
    let mut store = Store::new(&engine, ());
    let i = linker.instantiate(&mut store, &component)?;

    assert_eq!(i.get_resource(&mut store, "t1"), Some(t2));
    assert_eq!(i.get_resource(&mut store, "t2"), Some(t2));

    Ok(())
}