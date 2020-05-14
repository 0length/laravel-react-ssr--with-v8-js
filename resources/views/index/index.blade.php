
@extends('master')
@section('title')
{!! $title !!}
@endsection
@section('content')
<div id='{!! $path !!}'>{!! $isServerRenderingEnabled ? $markup : '' !!}</div>
@endsection
@section('script')
<script src="{{ asset('/script/index.js') }}"></script>

<script>
    document.onreadystatechange = function () {
      if (document.readyState === 'complete') {
        
        ReactDom.{!! $isServerRenderingEnabled ?'hydrate':'render'!!}(
          React.createElement({!! $ComponentName !!}, {!! $props !!}),
          document.getElementById('{!! $path !!}')
        );
        
      }
    }
</script>
@endsection