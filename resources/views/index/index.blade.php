
@extends('master')
@section('content')
<div id="app">{!! $isServerRenderingEnabled ? $markup : '' !!}</div>
@endsection
@section('script')
<script src="{{ asset('/script/index.js') }}"></script>

<script>
    document.onreadystatechange = function () {
      if (document.readyState === 'complete') {
        
        ReactDom.{!! $isServerRenderingEnabled ?'hydrate':'render'!!}(
          React.createElement({!! $ComponentName !!}, {}),
          document.getElementById('app')
        );
        
      }
    }
</script>
@endsection