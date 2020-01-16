import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'dart:typed_data';
part 'model.g.dart';

const tableUser = SqfEntityTable(
  tableName: 'user',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('firstName', DbType.text),
    SqfEntityField('lastName', DbType.text),
    SqfEntityField('email', DbType.text),
    SqfEntityField('password', DbType.text),
    SqfEntityField('private_key', DbType.text),
    SqfEntityField('public_key', DbType.text),
    SqfEntityField('profileUrl', DbType.text),
    SqfEntityField('isActive', DbType.bool, defaultValue: true),
    SqfEntityField('createdAt', DbType.integer),
    SqfEntityField('updatedAt', DbType.integer),
  ],
);

const tableFolder = SqfEntityTable(
  tableName: 'folder',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('title', DbType.text),
    SqfEntityField('picture', DbType.blob),
    SqfEntityField('createdAt', DbType.integer),
    SqfEntityField('updatedAt', DbType.integer),
  ],
);

const tableMyImage = SqfEntityTable(
    tableName: 'picture',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    fields: [
      SqfEntityField('title', DbType.text),
      SqfEntityField('picture', DbType.blob),
      SqfEntityField('createdAt', DbType.integer),
      SqfEntityField('updatedAt', DbType.integer),
      SqfEntityField('isActive', DbType.bool, defaultValue: true),
      SqfEntityFieldRelationship(
          parentTable: tableFolder,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: '0')
    ]);

@SqfEntityBuilder(agreementModel)
const agreementModel = SqfEntityModel(
  //bundledDatabasePath: 'assets/agreement.sqlite',
  modelName: 'agreementModel',
  databaseName: 'agreement.db',
  databaseTables: [tableMyImage, tableFolder, tableUser],
);
